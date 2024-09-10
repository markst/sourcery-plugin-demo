import Foundation
import PackagePlugin

@main
struct SourceryPlugin: BuildToolPlugin {

    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return try createBuildCommands(
            tool: try context.tool(named: "sourcery"),
            configPath: context.package.directory.appending("sourcery.yml"),
            pluginWorkDirectory: context.pluginWorkDirectory
        )
    }

    private func createBuildCommands(
        tool: PluginContext.Tool,
        configPath: Path,
        pluginWorkDirectory: Path
    ) throws -> [Command] {
        let outputDirectory = pluginWorkDirectory.appending("SourceryGenerated")
        let cachePath = pluginWorkDirectory.appending(subpath: "Cache")
        let buildPath = pluginWorkDirectory.appending(subpath: "Build")

        // Assuming sourcery will create intermediate directories, so unnecessary:
        try FileManager.default.createDirectory(atPath: outputDirectory.string,
                                                withIntermediateDirectories: true)
        try FileManager.default.createDirectory(atPath: buildPath.string,
                                                withIntermediateDirectories: true)
        try FileManager.default.createDirectory(atPath: buildPath.string,
                                                withIntermediateDirectories: true)

        Diagnostics.remark("Generating mocks in directory: \(outputDirectory)")

        return [
            .buildCommand(
                displayName: "Generate mocked types for target",
                executable: tool.path,
                arguments: [
                    "--config", configPath,
                    "--cacheBasePath", cachePath.string,
                    "--buildPath", buildPath.string,
                    "--verbose"
                ],
                environment: ["OUTPUT_DIR": outputDirectory],
                outputFiles: [
                    outputDirectory.appending("Mock.generated.swift")
                ]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SourceryPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        return try createBuildCommands(
            tool: try context.tool(named: "sourcery"),
            configPath: context.xcodeProject.directory.appending("sourcery.yml"),
            pluginWorkDirectory: context.pluginWorkDirectory
        )
    }
}
#endif
