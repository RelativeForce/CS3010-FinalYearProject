module Revoked.Assets.Images.ToxicWaste where

toxicWasteData :: String
toxicWasteData = "data:image/png;base64,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"