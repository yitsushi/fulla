package main

import (
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
)

func serveCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "serve",
		Short: "start http server",
		RunE: func(cmd *cobra.Command, args []string) error {
			logrus.Debug("Start server...")

			return nil
		},
	}

	return cmd
}
