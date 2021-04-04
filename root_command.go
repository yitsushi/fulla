package main

import (
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

func rootCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "fulla",
		Short: "Just put it in my box...",
		Long:  "Simple image galler with S3 compatible backend",
		PersistentPreRun: func(cmd *cobra.Command, args []string) {
			if value, _ := cmd.Flags().GetBool("debug"); value {
				logrus.SetLevel(logrus.DebugLevel)
			}
		},
	}

	cmd.PersistentFlags().Bool("debug", false, "spam stdout with debug information")

	cmd.AddCommand(serveCommand())
	cmd.AddCommand(thumbnailCommand())

	return cmd
}
