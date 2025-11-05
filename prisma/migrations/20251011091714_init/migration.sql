/*
  Warnings:

  - Added the required column `description` to the `game` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "public"."challenge_like" DROP CONSTRAINT "challenge_like_challenge_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."challenge_like" DROP CONSTRAINT "challenge_like_user_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."participation_like" DROP CONSTRAINT "participation_like_participation_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."participation_like" DROP CONSTRAINT "participation_like_user_id_fkey";

-- AlterTable
ALTER TABLE "game" ADD COLUMN     "description" VARCHAR(255) NOT NULL;

-- CreateTable
CREATE TABLE "type" (
    "type_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "type_pkey" PRIMARY KEY ("type_id")
);

-- CreateTable
CREATE TABLE "type_game" (
    "game_id" INTEGER NOT NULL,
    "type_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "type_game_pkey" PRIMARY KEY ("game_id","type_id")
);

-- CreateTable
CREATE TABLE "platform" (
    "platform_id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "platform_pkey" PRIMARY KEY ("platform_id")
);

-- CreateTable
CREATE TABLE "platform_game" (
    "game_id" INTEGER NOT NULL,
    "platform_id" INTEGER NOT NULL,

    CONSTRAINT "platform_game_pkey" PRIMARY KEY ("game_id","platform_id")
);

-- CreateIndex
CREATE INDEX "type_deleted_at_idx" ON "type"("deleted_at");

-- CreateIndex
CREATE INDEX "type_game_game_id_idx" ON "type_game"("game_id");

-- CreateIndex
CREATE INDEX "type_game_type_id_idx" ON "type_game"("type_id");

-- CreateIndex
CREATE INDEX "platform_deleted_at_idx" ON "platform"("deleted_at");

-- CreateIndex
CREATE INDEX "platform_game_game_id_idx" ON "platform_game"("game_id");

-- CreateIndex
CREATE INDEX "platform_game_platform_id_idx" ON "platform_game"("platform_id");

-- CreateIndex
CREATE INDEX "challenge_deleted_at_idx" ON "challenge"("deleted_at");

-- CreateIndex
CREATE INDEX "game_deleted_at_idx" ON "game"("deleted_at");

-- CreateIndex
CREATE INDEX "participation_deleted_at_idx" ON "participation"("deleted_at");

-- CreateIndex
CREATE INDEX "role_deleted_at_idx" ON "role"("deleted_at");

-- CreateIndex
CREATE INDEX "user_deleted_at_idx" ON "user"("deleted_at");

-- CreateIndex
CREATE INDEX "user_role_deleted_at_idx" ON "user_role"("deleted_at");

-- AddForeignKey
ALTER TABLE "challenge_like" ADD CONSTRAINT "challenge_like_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "challenge_like" ADD CONSTRAINT "challenge_like_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "challenge"("challenge_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participation_like" ADD CONSTRAINT "participation_like_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "participation_like" ADD CONSTRAINT "participation_like_participation_id_fkey" FOREIGN KEY ("participation_id") REFERENCES "participation"("participation_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "type_game" ADD CONSTRAINT "type_game_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("game_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "type_game" ADD CONSTRAINT "type_game_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "type"("type_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_game" ADD CONSTRAINT "platform_game_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("game_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_game" ADD CONSTRAINT "platform_game_platform_id_fkey" FOREIGN KEY ("platform_id") REFERENCES "platform"("platform_id") ON DELETE RESTRICT ON UPDATE CASCADE;
