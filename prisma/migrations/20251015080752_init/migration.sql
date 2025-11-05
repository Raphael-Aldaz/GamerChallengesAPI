/*
  Warnings:

  - You are about to drop the column `avatar_user_id` on the `media` table. All the data in the column will be lost.
  - You are about to drop the column `game_id` on the `media` table. All the data in the column will be lost.
  - You are about to drop the column `participation_id` on the `media` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "public"."media" DROP CONSTRAINT "media_avatar_user_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."media" DROP CONSTRAINT "media_game_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."media" DROP CONSTRAINT "media_participation_id_fkey";

-- DropIndex
DROP INDEX "public"."media_avatar_user_id_key";

-- DropIndex
DROP INDEX "public"."media_game_id_idx";

-- DropIndex
DROP INDEX "public"."media_participation_id_key";

-- AlterTable
ALTER TABLE "media" DROP COLUMN "avatar_user_id",
DROP COLUMN "game_id",
DROP COLUMN "participation_id";

-- CreateTable
CREATE TABLE "user_avatar" (
    "user_avatar_id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "media_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "user_avatar_pkey" PRIMARY KEY ("user_avatar_id")
);

-- CreateTable
CREATE TABLE "game_image" (
    "game_image_id" SERIAL NOT NULL,
    "game_id" INTEGER NOT NULL,
    "media_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "game_image_pkey" PRIMARY KEY ("game_image_id")
);

-- CreateTable
CREATE TABLE "participation_video" (
    "participation_video_id" SERIAL NOT NULL,
    "participation_id" INTEGER NOT NULL,
    "media_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "participation_video_pkey" PRIMARY KEY ("participation_video_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_avatar_user_id_key" ON "user_avatar"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_avatar_media_id_key" ON "user_avatar"("media_id");

-- CreateIndex
CREATE INDEX "user_avatar_media_id_idx" ON "user_avatar"("media_id");

-- CreateIndex
CREATE INDEX "game_image_game_id_idx" ON "game_image"("game_id");

-- CreateIndex
CREATE INDEX "game_image_media_id_idx" ON "game_image"("media_id");

-- CreateIndex
CREATE UNIQUE INDEX "participation_video_participation_id_key" ON "participation_video"("participation_id");

-- CreateIndex
CREATE UNIQUE INDEX "participation_video_media_id_key" ON "participation_video"("media_id");

-- CreateIndex
CREATE INDEX "participation_video_media_id_idx" ON "participation_video"("media_id");

-- CreateIndex
CREATE INDEX "media_deleted_at_idx" ON "media"("deleted_at");

-- AddForeignKey
ALTER TABLE "user_avatar" ADD CONSTRAINT "user_avatar_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_avatar" ADD CONSTRAINT "user_avatar_media_id_fkey" FOREIGN KEY ("media_id") REFERENCES "media"("media_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_image" ADD CONSTRAINT "game_image_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("game_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_image" ADD CONSTRAINT "game_image_media_id_fkey" FOREIGN KEY ("media_id") REFERENCES "media"("media_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participation_video" ADD CONSTRAINT "participation_video_participation_id_fkey" FOREIGN KEY ("participation_id") REFERENCES "participation"("participation_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participation_video" ADD CONSTRAINT "participation_video_media_id_fkey" FOREIGN KEY ("media_id") REFERENCES "media"("media_id") ON DELETE CASCADE ON UPDATE CASCADE;
