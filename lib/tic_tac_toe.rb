# tic_tac_toe.rb

class TicTacToe
  def initialize
    @board = Array.new(3) { Array.new(3, ' ') }
    @current_player = 'X'
    @against_ai = false
  end

  def play
    puts 'Do you want to play against an AI? (y/n)'
    @against_ai = gets.chomp.casecmp('y').zero?

    loop do
      display_board
      player_move
      if winner?
        display_board
        puts "Player #{@current_player} wins!"
        break
      elsif draw?
        display_board
        puts "It's a draw!"
        break
      end
      switch_player
    end
  end

  private

  def ai_move
    empty_cells = []
    @board.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        empty_cells << [i, j] if cell == ' '
      end
    end

    block_opponent_move || empty_cells.sample
  end

  def block_opponent_move
    winning_combinations.each do |combo|
      next unless combo.count { |row, col| @board[row][col] == 'O' } == 2

      combo.each do |row, col|
        return [row, col] if @board[row][col] == ' '
      end
    end

    nil
  end

  def display_board
    @board.each do |row|
      puts row.join(' | ')

      puts '--+---+--' unless row.equal?(@board.last)
    end
  end

  def player_move
    row, col =
      if @against_ai && @current_player == 'O'
        puts 'AI opponent planning move...'
        sleep(2)
        ai_move
      else
        puts "Player #{@current_player}, enter your move (row and column): "
        gets.split.map(&:to_i)
      end

    if valid_move?(row, col)
      @board[row][col] = @current_player
    else
      puts 'Invalid move. Try again.'
      player_move
    end
  end

  def valid_move?(row, col)
    row.between?(0, 2) && col.between?(0, 2) && @board[row][col] == ' '
  end

  def switch_player
    @current_player = @current_player == 'X' ? 'O' : 'X'
  end

  def winner?
    winning_combinations.any? do |combo|
      # puts "combo: #{combo}"
      combo.all? do |row, col|
        # puts "row: #{row}, col: #{col}"
        @board[row][col] == @current_player
      end
    end
  end

  def draw?
    @board.flatten.none? { |cell| cell == ' ' }
  end

  def winning_combinations
    rows = (0..2).map { |i| [[i, 0], [i, 1], [i, 2]] }
    cols = rows.transpose
    diags = [[[0, 0], [1, 1], [2, 2]], [[0, 2], [1, 1], [2, 0]]]
    rows + cols + diags
  end

  def play_again?
    puts 'Do you want to play again? (y/n)'
    gets.chomp.casecmp('y').zero?
  end
end

game = TicTacToe.new
game.play
