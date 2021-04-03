package main

func main() {
	root := rootCommand()

	root.AddCommand(versionCommand())

	_ = root.Execute()
}
