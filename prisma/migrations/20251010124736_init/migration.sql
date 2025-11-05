/*
  Warnings:

  - You are about to drop the column `desciption` on the `challenge` table. All the data in the column will be lost.
  - You are about to alter the column `title` on the `challenge` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(255)`.
  - You are about to drop the column `game_image` on the `game` table. All the data in the column will be lost.
  - You are about to alter the column `title` on the `game` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(255)`.
  - You are about to alter the column `role_name` on the `role` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(50)`.
  - You are about to drop the column `avatar` on the `user` table. All the data in the column will be lost.
  - You are about to alter the column `pseudo` on the `user` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(50)`.
  - You are about to alter the column `email` on the `user` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(255)`.
  - You are about to alter the column `password` on the `user` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(255)`.
  - You are about to drop the `ChallengeLike` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ParticipationLike` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `UserRole` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `particiation` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `description` to the `challenge` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "MediaType" AS ENUM ('IMAGE', 'VIDEO');

-- DropForeignKey
ALTER TABLE "public"."ChallengeLike" DROP CONSTRAINT "ChallengeLike_challenge_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."ChallengeLike" DROP CONSTRAINT "ChallengeLike_user_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."ParticipationLike" DROP CONSTRAINT "ParticipationLike_participation_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."ParticipationLike" DROP CONSTRAINT "ParticipationLike_user_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."UserRole" DROP CONSTRAINT "UserRole_role_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."UserRole" DROP CONSTRAINT "UserRole_user_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."challenge" DROP CONSTRAINT "challenge_game_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."challenge" DROP CONSTRAINT "challenge_user_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."particiation" DROP CONSTRAINT "particiation_challenge_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."particiation" DROP CONSTRAINT "particiation_user_id_fkey";

-- AlterTable
ALTER TABLE "challenge" DROP COLUMN "desciption",
ADD COLUMN     "description" TEXT NOT NULL,
ALTER COLUMN "title" SET DATA TYPE VARCHAR(255),
ALTER COLUMN "updated_at" DROP DEFAULT,
ALTER COLUMN "deleted_at" DROP NOT NULL,
ALTER COLUMN "deleted_at" DROP DEFAULT;

-- AlterTable
ALTER TABLE "game" DROP COLUMN "game_image",
ALTER COLUMN "title" SET DATA TYPE VARCHAR(255),
ALTER COLUMN "updated_at" DROP DEFAULT,
ALTER COLUMN "deleted_at" DROP NOT NULL,
ALTER COLUMN "deleted_at" DROP DEFAULT;

-- AlterTable
ALTER TABLE "role" ALTER COLUMN "role_name" SET DATA TYPE VARCHAR(50),
ALTER COLUMN "updated_at" DROP DEFAULT,
ALTER COLUMN "deleted_at" DROP NOT NULL,
ALTER COLUMN "deleted_at" DROP DEFAULT;

-- AlterTable
ALTER TABLE "user" DROP COLUMN "avatar",
ALTER COLUMN "pseudo" SET DATA TYPE VARCHAR(50),
ALTER COLUMN "email" SET DATA TYPE VARCHAR(255),
ALTER COLUMN "password" SET DATA TYPE VARCHAR(255),
ALTER COLUMN "updated_at" DROP DEFAULT,
ALTER COLUMN "deleted_at" DROP NOT NULL,
ALTER COLUMN "deleted_at" DROP DEFAULT;

-- DropTable
DROP TABLE "public"."ChallengeLike";

-- DropTable
DROP TABLE "public"."ParticipationLike";

-- DropTable
DROP TABLE "public"."UserRole";

-- DropTable
DROP TABLE "public"."particiation";

-- CreateTable
CREATE TABLE "user_role" (
    "user_id" INTEGER NOT NULL,
    "role_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "user_role_pkey" PRIMARY KEY ("user_id","role_id")
);

-- CreateTable
CREATE TABLE "participation" (
    "participation_id" SERIAL NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "user_id" INTEGER NOT NULL,
    "challenge_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "participation_pkey" PRIMARY KEY ("participation_id")
);

-- CreateTable
CREATE TABLE "challenge_like" (
    "user_id" INTEGER NOT NULL,
    "challenge_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "challenge_like_pkey" PRIMARY KEY ("user_id","challenge_id")
);

-- CreateTable
CREATE TABLE "participation_like" (
    "user_id" INTEGER NOT NULL,
    "participation_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "participation_like_pkey" PRIMARY KEY ("user_id","participation_id")
);

-- CreateTable
CREATE TABLE "media" (
    "media_id" SERIAL NOT NULL,
    "filename" VARCHAR(255) NOT NULL,
    "original_name" VARCHAR(255) NOT NULL,
    "mimetype" VARCHAR(100) NOT NULL,
    "size" INTEGER NOT NULL,
    "path" VARCHAR(500) NOT NULL,
    "type" "MediaType" NOT NULL,
    "avatar_user_id" INTEGER,
    "game_id" INTEGER,
    "participation_id" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "media_pkey" PRIMARY KEY ("media_id")
);

-- CreateIndex
CREATE INDEX "participation_user_id_idx" ON "participation"("user_id");

-- CreateIndex
CREATE INDEX "participation_challenge_id_idx" ON "participation"("challenge_id");

-- CreateIndex
CREATE INDEX "challenge_like_challenge_id_idx" ON "challenge_like"("challenge_id");

-- CreateIndex
CREATE INDEX "challenge_like_user_id_idx" ON "challenge_like"("user_id");

-- CreateIndex
CREATE INDEX "participation_like_participation_id_idx" ON "participation_like"("participation_id");

-- CreateIndex
CREATE INDEX "participation_like_user_id_idx" ON "participation_like"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "media_filename_key" ON "media"("filename");

-- CreateIndex
CREATE UNIQUE INDEX "media_avatar_user_id_key" ON "media"("avatar_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "media_participation_id_key" ON "media"("participation_id");

-- CreateIndex
CREATE INDEX "media_game_id_idx" ON "media"("game_id");

-- CreateIndex
CREATE INDEX "challenge_user_id_idx" ON "challenge"("user_id");

-- CreateIndex
CREATE INDEX "challenge_game_id_idx" ON "challenge"("game_id");

-- AddForeignKey
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "role"("role_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "challenge" ADD CONSTRAINT "challenge_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "challenge" ADD CONSTRAINT "challenge_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("game_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participation" ADD CONSTRAINT "participation_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participation" ADD CONSTRAINT "participation_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "challenge"("challenge_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "challenge_like" ADD CONSTRAINT "challenge_like_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "challenge_like" ADD CONSTRAINT "challenge_like_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "challenge"("challenge_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participation_like" ADD CONSTRAINT "participation_like_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participation_like" ADD CONSTRAINT "participation_like_participation_id_fkey" FOREIGN KEY ("participation_id") REFERENCES "participation"("participation_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media" ADD CONSTRAINT "media_avatar_user_id_fkey" FOREIGN KEY ("avatar_user_id") REFERENCES "user"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media" ADD CONSTRAINT "media_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("game_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media" ADD CONSTRAINT "media_participation_id_fkey" FOREIGN KEY ("participation_id") REFERENCES "participation"("participation_id") ON DELETE CASCADE ON UPDATE CASCADE;
