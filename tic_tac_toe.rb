class Player
    attr_accessor :marker, :status

    def initialize(marker)
        @marker = marker
        @status = "playing"
    end
end

class User < Player
    attr_accessor :name

    def initialize(marker)
        super
        @name = "Human user"
    end
end

class Computer < Player
    attr_accessor :name

    def initialize(marker)
        super
        @name = "Computer"
    end
end

class Game
    WINS = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 6], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

    attr_accessor :board, :winner, :user, :computer, :current_player

    def initialize
        @board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        @open_moves = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        @winner = nil
        user_marker = "A"
        until user_marker == "X" || user_marker == "O"
            print "Do you want to be X or O? "
            user_marker = gets.chomp.upcase
            print "\n"
        end
        @user = User.new(user_marker)
        @computer = user_marker == "X" ? Computer.new("O") : Computer.new("X")
        @current_player = self.computer.marker == "X" ? "computer" : "user"
    end

    def play()
        loop do
            unless self.winner == nil
                print_grid
            end
            if self.winner == "user"
                puts "You're the winner!!"
                break
            elsif self.winner == "computer"
                puts "Sorry, you lost :("
                break
            elsif self.winner == "tie"
                puts "It's a tie!"
                break
            end
            if self.current_player == 'user'
                print_grid
            end
            make_move
        end
    end

    def make_move
        computer_move = nil
        player_move = nil
        if self.current_player == "user"
            valid_move = false
            until valid_move
                print "What's your move?  "
                player_move = gets.chomp
                if player_move.upcase == "E" || player_move.upcase == "EXIT"
                    exit
                else
                    player_move = player_move.to_i
                end
                valid_move = add_move(player_move, self.user)
                print "\n"
            end
        else
            for line in WINS
                moves = []
                line.each do |cell|
                    pos = find_position(cell)
                    moves.push(self.board[pos[0]][pos[1]])
                end
                block = moves.uniq.length == 2 ? true : false
                if block
                    for cell in moves
                        if cell.is_a? Numeric
                            computer_move = cell
                        end
                    end
                end
            end
            computer_move = computer_move.nil? ? @open_moves.shuffle.first : computer_move
            add_move(computer_move, self.computer)
        end
        if self.current_player == "computer"
            puts "Computer chose #{computer_move}\n\n"
            @open_moves.delete(computer_move)
        else
            @open_moves.delete(player_move)
        end
        check_win
        self.current_player = self.current_player == "user" ? "computer" : "user"
    end

    def add_move(cell, player)
        get_pos = find_position(cell)
        row = get_pos[0]
        col = get_pos[1]
        move_cell = self.board[row][col] 
        if move_cell == "X" || move_cell == "O"
            print player.name == 'user' ? "That cell is already taken, try again\n" : ""
            return false
        else
            self.board[row][col] = player.marker
            return true
        end
    end

    def check_win
        for line in WINS
            moves = []
            for cell in line
                position = find_position(cell)
                moves.push(self.board[position[0]][position[1]])
            end
            if moves.uniq.length == 1
                if moves[0] == self.computer.marker
                    self.winner = "computer"
                    break
                else
                    self.winner = "user"
                    break
                end
            end
        end
        if @open_moves.length == 0
            self.winner = "tie"
        end
    end

    def find_position(cell)
        cell -= 1
        row = cell / 3
        col = cell - (row * 3)
        return [row, col]
    end

    def print_grid
        self.board.each_with_index do |row, index|
            row.each_with_index do |cell, cell_index|
                print " "
                print cell
                print " "
                print cell_index == row.length - 1 ? "\n" : "|"
            end
            puts index == row.length - 1 ? "" : "--- --- ---"
        end
    end
    
end

puts "If you ever want to quit, enter \"E\" or \"EXIT\" \n\n"

Game.new.play

play_again = "Y"
until play_again == "N" || play_again == "NO"
    print "Would you like to play again? "
    play_again = gets.chomp.upcase
    if play_again == "Y" || play_again == "Yes"
        Game.new.play
    end
    if play_again == "E" || play_again == "EXIT"
        exit
    end
end

exit