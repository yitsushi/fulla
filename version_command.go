package main

import (
	"fmt"

	"github.com/spf13/cobra"
)

//nolint:gochecknoglobals // Used by ldflags
var (
	version = "dev"
	commit  = "none"
	date    = "unknown"
	builtBy = "unknown"
)

func versionCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "version",
		Short: "Print the version number for fulla",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("my app %s, commit %s, built at %s by %s", version, commit, date, builtBy)
		},
	}

	return cmd
}
