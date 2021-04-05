package main

import (
	"github.com/spf13/cobra"

	"gitea.code-infection.com/efertone/fulla/storage"
)

func thumbnailCommand() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "thumbnail",
		Short: "generate thumbnails",
		RunE: func(cmd *cobra.Command, args []string) error {
			numberOfWorkers, flagErr := cmd.Flags().GetInt("workers")
			if flagErr != nil {
				return flagErr
			}

			return storage.GenerateAllThumbnails(numberOfWorkers)
		},
	}

	cmd.Flags().Int("workers", 8, "Number of workers")

	return cmd
}
