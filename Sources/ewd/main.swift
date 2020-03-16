import Foundation
import Files
import Rainbow

let RootFolderName = ".ewd"
let CommandFile = "ewd.json"

var currentProcess: Process?

func signalHandler(signal: Int32) {
    currentProcess?.terminate()
}

let signals = [SIGINT, SIGTERM, SIGKILL]
for sig in signals {
    signal(sig, signalHandler)
}

func executeCommand(_ command: String) {
    currentProcess = Process()
    currentProcess?.launchPath = "/bin/bash"
    currentProcess?.arguments = ["-c", command]
    currentProcess?.launch()
    currentProcess?.waitUntilExit()
}

func pwdFile() throws -> File {
    if !Folder.home.containsSubfolder(at: RootFolderName) {
        try Folder.home.createSubfolder(named: RootFolderName)
    }
    let rootFolder = try Folder.home.subfolder(named: RootFolderName)
    let pwd = FileManager.default.currentDirectoryPath
    
    if !rootFolder.containsSubfolder(at: pwd) {
        try rootFolder.createSubfolder(at: pwd)
    }
    let currentFolder = try rootFolder.subfolder(at: pwd)
    if !currentFolder.containsFile(named: CommandFile) {
        try currentFolder.createFileIfNeeded(withName: CommandFile)
        let file = try currentFolder.file(named: CommandFile)
        try file.write("{}")
    }
    return try currentFolder.file(named: CommandFile)
}

func commands() throws -> [String: String] {
    let file = try pwdFile()
    return try JSONDecoder().decode([String: String].self, from: try file.read())
}

func command(named: String) throws -> String? {
    try commands()[named]
}

func setCommand(named: String, value: String) throws {
    var currentCommands = try commands()
    currentCommands[named] = value
    let file = try pwdFile()
    let data = try JSONEncoder().encode(currentCommands)
    try file.write(data)
}

func deleteCommand(named: String) throws {
    var currentCommands = try commands()
    currentCommands.removeValue(forKey: named)
    let file = try pwdFile()
    let data = try JSONEncoder().encode(currentCommands)
    try file.write(data)
}

func help() {
    print("""
    ewd: save and execute commands for the local directory

    execute command:
       ewd <command>

    set command:
       ewd --set <command> "<value>"

    show command:
       ewd --show <command>

    list all commands:
       ewd --list

    delete command:
       ewd --delete <command>
    """)
    exit(0)
}

var args = CommandLine.arguments
args.remove(at: 0)

if (args.first { $0 == "help" || $0 == "--help" }) != nil {
    help()
}

if (args.first { $0 == "--zsh-completion-list" }) != nil {
    let allCommands = try commands()
    print(allCommands.keys.sorted().joined(separator: " "))
    exit(0)
}

if (args.first { $0 == "--set" }) != nil {
    args.remove(at: 0)
    if args.count != 2 {
        help()
    }
    try setCommand(named: args[0], value: args[1])
    exit(0)
}

if (args.first { $0 == "--show" }) != nil {
    args.remove(at: 0)
    if args.count != 1 {
        help()
    }
    if let command = try command(named: args[0]) {
        print(command)
        exit(0)
    }
}

if (args.first { $0 == "--list" }) != nil {
    let allCommands = try commands()
    let commandStrings = allCommands.keys.sorted().map { (key) in
        "\(key.green): \(allCommands[key]!)"
    }
    print(commandStrings.joined(separator: "\n"))
    exit(0)
}

if (args.first { $0 == "--delete" }) != nil {
    args.remove(at: 0)
    if args.count != 1 {
        help()
    }
    try deleteCommand(named: args[0])
    exit(0)
}

if args.count == 1 {
    if let command = try command(named: args[0]) {
        executeCommand(command)
        exit(0)
    } else {
        print(args[0] + " is not a stored command name")
    }
    exit(0)
}

help()
