; Inno Setup 6 — build on Windows: iscc setup.iss
; Uses the same branding icon as all platforms: ..\..\dist\windows\app.ico
#define MyAppName "GSBuilder.AI"
#define MyAppVersion "1.3.0"
#define MyAppPublisher "GSBuilder.AI"
#define MyAppURL "https://github.com/vishnupranu/gaijsbuilder.ai"
#define RepoRoot "..\.."

[Setup]
AppId={{F7E6D5C4-B3A2-1098-7654-3210FEDCBA09}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName={userpf}\GSBuilder.AI
DisableProgramGroupPage=yes
OutputDir={#RepoRoot}\dist\windows-installer
OutputBaseFilename=GSBuilder.AI-Setup-{#MyAppVersion}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
SetupIconFile={#RepoRoot}\dist\windows\app.ico
UninstallDisplayIcon={app}\app.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "{#RepoRoot}\gsbuilder-ai"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#RepoRoot}\installers\windows\gsbuilder-ai.cmd"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#RepoRoot}\brand\*"; DestDir: "{app}\brand"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#RepoRoot}\dist\windows\app.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}\GSBuilder.AI cmd"; Filename: "{app}\gsbuilder-ai.cmd"; IconFilename: "{app}\app.ico"
Name: "{autoprograms}\{#MyAppName}\Uninstall"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\gsbuilder-ai.cmd"; Parameters: "version"; Description: "Check version"; Flags: postinstall shellexec skipifsilent
