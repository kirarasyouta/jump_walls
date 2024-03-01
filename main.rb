require 'dxruby'

Window.width = 1920
Window.height = 1200
Window.windowed = false

player = Sprite.new(960, 1000, Image.new(100, 100, C_WHITE))
player2 = Sprite.new(960, 1000, Image.new(100, 100, C_YELLOW))

ground = [
    Sprite.new(0, 1180, Image.new(1920, 20, C_GREEN))
]

walls = []

walls_spead = 10
wall_height = 280
wall_height_x = 900
wall_count = 342
wall_spawn = true
wall_height_rand = 1

wall2_height = 480
wall2_height_x = 20

jump = 0
jump_count = 0
jump2 = 0
jump2_count = 0

game_start = true
game_los = false
game2_los = false
game3_los = false

Window.loop do
    if game_start
        Window.draw_font(100, 100, "ぴーですたと", Font.default)
        if Input.key_push?(K_P)
            game_start = false
        end
    elsif game3_los
        Window.draw_font(100, 100, "引き分け！\nぴーでしょきがめん", Font.default)
        if Input.key_push?(K_P)
            game_start = true
            game_los = false
            game2_los = false
            game3_los = false
            player.x = 960
            player2.x = 960
            player.y = 1000
            player2.y = 1000
            walls_spead = 10
            wall_height = 280
            wall_height_x = 900
            wall_count = 342
            wall_height_rand = 1
        end
    elsif game_los
        Window.draw_font(100, 100, "白プレイヤーの負け！\nぴーでしょきがめん", Font.default)
        if Input.key_push?(K_P)
            game_start = true
            game_los = false
            player.x = 960
            player2.x = 960
            player.y = 1000
            player2.y = 1000
            walls_spead = 10
            wall_height = 280
            wall_height_x = 900
            wall_count = 342
            wall_height_rand = 1
        end
    elsif game2_los
        Window.draw_font(100, 100, "黄色プレイヤーの負け！\nぴーでしょきがめん", Font.default)
        if Input.key_push?(K_P)
            game_start = true
            game2_los = false
            player.x = 960
            player2.x = 960
            player.y = 1000
            player2.y = 1000
            walls_spead = 10
            wall_height = 280
            wall_height_x = 900
            wall_count = 342
            wall_height_rand = 1
        end
    else
        player.draw
        player2.draw
        Sprite.draw(ground)

        player.y += 20
        player2.y += 20
        
        Window.draw_font(100, 100, "ジャンプカウント#{jump}\nジャンプ制限#{jump_count}\n壁の配列#{walls.size}", Font.default)

        #プレイヤー１
        if jump_count < 3
            if Input.key_push?(K_SPACE)
                jump = 10
                jump_count += 1
            end
        end
        if jump > 0
            player.y -= 60
            jump -= 1
        end
        player.check(ground).each do
            player.y -= 20
            jump_count = 0
        end
        #プレイヤー２
        if jump2_count < 3
            if Input.key_push?(K_RETURN)
                jump2 = 10
                jump2_count += 1
            end
        end
        if jump2 > 0
            player2.y -= 60
            jump2 -= 1
        end
        player2.check(ground).each do
            player2.y -= 20
            jump2_count = 0
        end

        if wall_spawn
            wall = Sprite.new(1920, wall_height_x, Image.new(150, wall_height, C_BLUE))
            walls.push(wall)
            wall_spawn = false
        end
        Sprite.draw(walls)
        if !walls.empty?
            walls.each do |obj|
                if obj.x > -150
                    obj.x -= walls_spead
                end
                if obj.x <= -150
                    obj.vanish
                    wall_spawn = true
                    walls_spead = rand(10..30)
                    wall_height_rand = rand(1..3)
                end
                # if (game_los == true) || (game2_los == true) || (game3_los == true)
                #     obj.vanish
                #     puts "S"
                # end
            end
            Sprite.clean(walls)
        end
        if wall_height_rand == 1
            wall_height = 280
            wall_height_x = 900
        end
        if wall_height_rand == 2
            wall_height = 380
            wall_height_x = 800
        end
        if wall_height_rand == 3
            wall_height = 480
            wall_height_x = 700
        end
        # if wall_height_rand == 4
        #     wall_height = 480
        #     wall_height_x = 700
        #     wall2 = Sprite.new(1920, wall2_height_x, Image.new(150, wall2_height, C_BLUE))
        #     walls.push(wall2)
        #     wall2_height = 480
        #     wall2_height_x = 20
        # end

        player.check(walls).each do
            player.x -= 200
        end
        player2.check(walls).each do
            player2.x -= 200
        end
        if (player.x < 100) && (player2.x < 100)
            game3_los = true
        end
        if player.x < 100
            game_los = true
        end
        if player2.x < 100
            game2_los = true
        end
    end
    break if Input.key_push?(K_ESCAPE)
end