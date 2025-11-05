-- DropForeignKey
ALTER TABLE "public"."platform_game" DROP CONSTRAINT "platform_game_game_id_fkey";

-- DropForeignKey
ALTER TABLE "public"."platform_game" DROP CONSTRAINT "platform_game_platform_id_fkey";

-- AddForeignKey
ALTER TABLE "platform_game" ADD CONSTRAINT "platform_game_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("game_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "platform_game" ADD CONSTRAINT "platform_game_platform_id_fkey" FOREIGN KEY ("platform_id") REFERENCES "platform"("platform_id") ON DELETE CASCADE ON UPDATE CASCADE;
