import Foundation
import CouncilKit

// A 30-second taste of CouncilKit: three advisors, one question, a divergence score.
//
// Keys: CouncilKit reads them from the macOS Keychain by default (set them in Council.app, or with
// `Council.setKey(_:for:)`). To keep this example self-contained we pass them in code from the
// environment instead — nothing is written to disk or the Keychain:
//
//   ANTHROPIC_API_KEY=… OPENAI_API_KEY=… GEMINI_API_KEY=… swift run
//
// Have a key for only one provider? Drop the other advisors — the run is tolerant of missing keys
// (those backends are simply skipped and listed in `result.failedAdvisors`).

@main
struct CouncilKitExample {
    static func main() async throws {
        let env = ProcessInfo.processInfo.environment
        let council = Council(
            advisors: [
                Advisor(backend: .claude, persona: .analyst),
                Advisor(backend: .gpt,    persona: .practitioner),
                Advisor(backend: .gemini, persona: .skeptic),
            ],
            keyProvider: { backend in
                switch backend {
                case .claude: return env["ANTHROPIC_API_KEY"]
                case .openAI: return env["OPENAI_API_KEY"]
                case .gemini: return env["GEMINI_API_KEY"]
                default:      return nil
                }
            }
        )

        let question = "Should a two-person startup adopt microservices on day one?"
        print("Q: \(question)\n")

        let result = try await council.deliberate(question)

        print("Divergence: \(result.divergence?.score ?? 0)/100  (0 = agree · 100 = poles apart)")
        if let analysis = result.divergence?.analysis { print(analysis) }

        for a in result.answers {
            print("\n— \(a.backend) —\n\(a.text)")
        }
        if let d = result.dissent {
            print("\n⚡️ Dissent — \(d.advisor):\n\(d.answer)")
        }
        print("\n=== Synthesis ===\n\(result.synthesis ?? "(needs at least two answers)")")
        print(String(format: "\nCost: $%.4f  (%d in / %d out tokens)",
                     result.cost.usd, result.cost.inputTokens, result.cost.outputTokens))

        if !result.failedAdvisors.isEmpty {
            let skipped = result.failedAdvisors.map { "\($0.backend) (\($0.error))" }.joined(separator: ", ")
            print("\nSkipped: \(skipped)")
        }
    }
}
