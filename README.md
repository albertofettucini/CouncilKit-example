# CouncilKit example

The shortest real program built on [CouncilKit](https://github.com/albertofettucini/CouncilKit):
three AI advisors answer one question, critique each other **blind**, and you get a 0–100
**divergence** score plus the dissenting view.

```sh
ANTHROPIC_API_KEY=… OPENAI_API_KEY=… GEMINI_API_KEY=… swift run
```

Only have one key? Delete the other advisors — CouncilKit skips any backend it can't reach and runs
with the rest.

The whole program is [`Sources/CouncilKitExample/Example.swift`](Sources/CouncilKitExample/Example.swift)
— about 30 lines.

See it with a full UI in [Council.app](https://github.com/albertofettucini/Council).
