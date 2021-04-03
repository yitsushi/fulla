package main

import (
	"github.com/spf13/cobra"

	"gitea.code-infection.com/efertone/fulla/server"
)

func serveCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "serve",
		Short: "start http server",
		RunE: func(cmd *cobra.Command, args []string) error {
			listen, flagErr := cmd.Flags().GetString("listen")
			if flagErr != nil {
				return flagErr
			}

			return server.Serve(listen)
		},
	}

	cmd.Flags().String("listen", "127.0.0.1:9876", "Listen address")

	return cmd
}
