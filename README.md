# My AL Tests

Automated AL test codeunits for Microsoft Dynamics 365 Business Central with comprehensive built-in function coverage.

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](#) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](#) [![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](#) [![Coverage](https://img.shields.io/badge/coverage-unknown-lightgrey.svg)](#)

## Table of Contents

- [Key Features](#key-features)
- [Installation](#installation)
- [Usage / Quick Start](#usage--quick-start)
- [Testing](#testing)
- [License](#license)
- [Authors / Acknowledgements](#authors--acknowledgements)

## Key Features

- Test coverage for AL built-in functions including:
  - String functions (e.g., `StrPos`, `IncStr`, `Replace`)
  - Date and time functions (e.g., `Today`, `WorkDate`, `CalcDate`)
  - Numeric functions (e.g., `Round`, `Power`, `Random`)
  - Array and list operations (e.g., `ArrayLen`, `CompressArray`, `List` methods)
  - System functions (e.g., `UserId`, `CompanyName`, `CreateDateTime`)
  - Variable handling functions (`Clear`, `ClearAll`, `Evaluate`, `Format`)
- Custom assertion helpers for DateTime comparisons with tolerance.
- Modular test codeunits for maintainability and reuse.
- Integration with AL Test Runner and Microsoft Test Libraries.

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```
2. Ensure your `app.json` includes dependencies on Microsoft test libraries:
   ```json
   "dependencies": [
     {
       "id": "dd0be2ea-f733-4d65-bb34-a28f4624fb14",
       "name": "Library Assert",
       "publisher": "Microsoft",
       "version": "25.0.0.0"
     },
     {
       "id": "5d86850b-0d76-4eca-bd7b-951ad998e997",
       "name": "Tests-TestLibraries",
       "publisher": "Microsoft",
       "version": "25.0.0.0"
     }
   ]
   ```
3. Download symbols in Visual Studio Code (Ctrl+Shift+P → AL: Download Symbols).
4. Build and publish your extension to your Business Central environment.

## Usage / Quick Start

- Run tests directly from Visual Studio Code using the AL Test Runner extension.
- Example test procedure snippet:
  ```al
  [Test]
  procedure StrPos_FindSubstring()
  var
      s: Text;
      pos: Integer;
      Assert: Codeunit Assert;
  begin
      s := 'Hello world';
      pos := StrPos(s, 'world'); // 1-based -> should return 7
      Assert.AreEqual(7, pos, 'StrPos did not return expected index.');
  end;
  ```
- Use the AL Test Runner UI or commands to execute and debug tests.

## Testing

- Tests are organized in codeunits named by function area (e.g., `StringFunctionTests`, `DateFunctionTests`).
- Run all tests via AL Test Runner or individual tests via VS Code test explorer.
- Test results and performance profiles are generated in the `.altestrunner/` folder (should be gitignored).
- Use `asserterror` to assert expected runtime errors in tests.

## License

MIT License. See [LICENSE](LICENSE) for details.

## Authors / Acknowledgements

- Developed by Thees-K.
- Uses Microsoft AL Test Libraries and AL Language extension.
- Inspired by official Microsoft AL documentation and training modules.
