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
			return storage.GenerateAllThumbnails()
		},
	}

	return cmd
}
