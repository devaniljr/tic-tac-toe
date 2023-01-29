require 'io/console'

module GameInput
    DIFFICULTIES = {
        'h' => 'hard',
        'm' => 'medium',
        'e' => 'easy'
    }

    GAME_TYPES = {
        '1' => 'p1_vs_com',
        '2' => 'p1_vs_p2',
        '3' => 'com_vs_com'
    }

    def self.get_difficulty
        puts "Choose game difficulty:\nH - Hard\nM - Medium\nE - Easy"

        loop do
            command = STDIN.gets.chomp.downcase

            if DIFFICULTIES.key?(command)
                puts "You have chosen the #{DIFFICULTIES[command].capitalize} difficulty"
                return DIFFICULTIES[command]
            else
                puts "Enter a valid option (h, m or e)"
            end
        end
    end

    def self.get_type
        puts "Who will play?\n1 - Me vs Computer\n2 - Me vs Friend\n3 - Computer vs Computer"

        loop do
            command = STDIN.gets.chomp
            if GAME_TYPES.key?(command)
                puts "You have chosen the #{GAME_TYPES[command].gsub("_"," ")} option."
                return GAME_TYPES[command]
            else
                puts "Enter a valid option (1, 2 or 3)."
            end
        end
    end

    def self.get_number_spot
        loop do
        command = STDIN.gets.chomp
            if command.match?(/\A\d+\z/) && command.to_i.between?(0, 8)
                return command.to_i
            else
                puts "Enter a valid position (0 to 8)."
            end
        end
    end
end