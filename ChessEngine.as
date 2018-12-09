package {
	public class ChessEngine {
		public var BLACK:String = 'b';
		public var WHITE:String = 'w';
		private var EMPTY:int = -1;
		
		public var PAWN:String = 'p';
		public var KNIGHT:String = 'n';
		public var BISHOP:String = 'b';
		public var ROOK:String = 'r';
		public var QUEEN:String = 'q';
		public var KING:String = 'k';
		private var SYMBOLS:String = 'pnbrqkPNBRQK';
		private var DEFAULT_POSITION:String = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
		private var POSSIBLE_RESULTS:Array = new Array('1-0', '0-1', '1/2-1/2', '*');
		
		private var PAWN_OFFSETS:Object = {
			b: new Array(16, 32, 17, 15),
			w: new Array(-16, -32, -17, -15)
		};
		
		private var PIECE_OFFSETS:Object = {
			n: new Array(-18, -33, -31, -14, 18, 33, 31, 14),
			b: new Array(-17, -15, 17, 15),
			r: new Array(-16, 1, 16, -1),
			q: new Array(-17, -16, -15, 1, 17, 16, 15, -1),
			k: new Array(-17, -16, -15, 1, 17, 16, 15, -1)
		};
		
		private var ATTACKS:Array = new Array(
			20, 0, 0, 0, 0, 0, 0, 24,  0, 0, 0, 0, 0, 0,20, 0,
			0,20, 0, 0, 0, 0, 0, 24,  0, 0, 0, 0, 0,20, 0, 0,
			0, 0,20, 0, 0, 0, 0, 24,  0, 0, 0, 0,20, 0, 0, 0,
			0, 0, 0,20, 0, 0, 0, 24,  0, 0, 0,20, 0, 0, 0, 0,
			0, 0, 0, 0,20, 0, 0, 24,  0, 0,20, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,20, 2, 24,  2,20, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 2,53, 56, 53, 2, 0, 0, 0, 0, 0, 0,
			24,24,24,24,24,24,56,  0, 56,24,24,24,24,24,24, 0,
			0, 0, 0, 0, 0, 2,53, 56, 53, 2, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,20, 2, 24,  2,20, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0,20, 0, 0, 24,  0, 0,20, 0, 0, 0, 0, 0,
			0, 0, 0,20, 0, 0, 0, 24,  0, 0, 0,20, 0, 0, 0, 0,
			0, 0,20, 0, 0, 0, 0, 24,  0, 0, 0, 0,20, 0, 0, 0,
			0,20, 0, 0, 0, 0, 0, 24,  0, 0, 0, 0, 0,20, 0, 0,
			20, 0, 0, 0, 0, 0, 0, 24,  0, 0, 0, 0, 0, 0,20
		);
		
		private var RAYS:Array = new Array(
			17,	 0,	 0,	 0,	 0,	 0,	 0, 16,	 0,	 0,	 0,	 0,	 0,	 0, 15, 0,
			0, 17,	0,	0,	0,	0,	0, 16,	0,	0,	0,	0,	0, 15,	0, 0,
			0,	0, 17,	0,	0,	0,	0, 16,	0,	0,	0,	0, 15,	0,	0, 0,
			0,	0,	0, 17,	0,	0,	0, 16,	0,	0,	0, 15,	0,	0,	0, 0,
			0,	0,	0,	0, 17,	0,	0, 16,	0,	0, 15,	0,	0,	0,	0, 0,
			0,	0,	0,	0,	0, 17,	0, 16,	0, 15,	0,	0,	0,	0,	0, 0,
			0,	0,	0,	0,	0,	0, 17, 16, 15,	0,	0,	0,	0,	0,	0, 0,
			1,	1,	1,	1,	1,	1,	1,	0, -1, -1,	-1,-1, -1, -1, -1, 0,
			0,	0,	0,	0,	0,	0,-15,-16,-17,	0,	0,	0,	0,	0,	0, 0,
			0,	0,	0,	0,	0,-15,	0,-16,	0,-17,	0,	0,	0,	0,	0, 0,
			0,	0,	0,	0,-15,	0,	0,-16,	0,	0,-17,	0,	0,	0,	0, 0,
			0,	0,	0,-15,	0,	0,	0,-16,	0,	0,	0,-17,	0,	0,	0, 0,
			0,	0,-15,	0,	0,	0,	0,-16,	0,	0,	0,	0,-17,	0,	0, 0,
			0,-15,	0,	0,	0,	0,	0,-16,	0,	0,	0,	0,	0,-17,	0, 0,
			-15,  0,  0,  0,  0,  0,  0,-16,  0,  0,  0,  0,  0,  0,-17
		);
		
		private var SHIFTS:Object = {
			p: 0,
			n: 1,
			b: 2,
			r: 3,
			q: 4,
			k: 5
		};
		
		public var FLAGS:Object = {
			NORMAL: 'n',
			CAPTURE: 'c',
			BIG_PAWN: 'b',
			EP_CAPTURE: 'e',
			PROMOTION: 'p',
			KSIDE_CASTLE: 'k',
			QSIDE_CASTLE: 'q'
		};
		
		private var BITS:Object = {
			NORMAL: 1,
			CAPTURE: 2,
			BIG_PAWN: 4,
			EP_CAPTURE: 8,
			PROMOTION: 16,
			KSIDE_CASTLE: 32,
			QSIDE_CASTLE: 64
		};
		
		private var RANK_1:int = 7;
		private var RANK_2:int = 6;
		private var RANK_3:int = 5;
		private var RANK_4:int = 4;
		private var RANK_5:int = 3;
		private var RANK_6:int = 2;
		private var RANK_7:int = 1;
		private var RANK_8:int = 0;
		
		private var SQUARES:Object = {
			a8:	  0, b8:   1, c8:	2, d8:	 3, e8:	  4, f8:   5, g8:	6, h8:	 7,
			a7:	 16, b7:  17, c7:  18, d7:	19, e7:	 20, f7:  21, g7:  22, h7:	23,
			a6:	 32, b6:  33, c6:  34, d6:	35, e6:	 36, f6:  37, g6:  38, h6:	39,
			a5:	 48, b5:  49, c5:  50, d5:	51, e5:	 52, f5:  53, g5:  54, h5:	55,
			a4:	 64, b4:  65, c4:  66, d4:	67, e4:	 68, f4:  69, g4:  70, h4:	71,
			a3:	 80, b3:  81, c3:  82, d3:	83, e3:	 84, f3:  85, g3:  86, h3:	87,
			a2:	 96, b2:  97, c2:  98, d2:	99, e2: 100, f2: 101, g2: 102, h2: 103,
			a1: 112, b1: 113, c1: 114, d1: 115, e1: 116, f1: 117, g1: 118, h1: 119
		};
		
		private var ROOKS:Object = {
			w: new Array(
				{square: SQUARES.a1, flag: BITS.QSIDE_CASTLE},
				{square: SQUARES.h1, flag: BITS.KSIDE_CASTLE}
			),
			b: new Array(
				{square: SQUARES.a8, flag: BITS.QSIDE_CASTLE},
				{square: SQUARES.h8, flag: BITS.KSIDE_CASTLE}
			)
		};
		
		private var board:Array = new Array();
		
		private var kings:Object = {
			w: EMPTY,
			b: EMPTY
		};
		
		public var turn:String = WHITE;
		
		private var castling:Object = {
			w: 0,
			b: 0
		};
		
		private var ep_square:int = EMPTY;
		private var half_moves:int = 0;
		private var move_number:int = 1;
		private var history:Array = new Array();
		private var header:Object = new Object();
		
		private function clear(keep_headers:Boolean = false):void {
			board = new Array();
			kings = {w: EMPTY, b: EMPTY};
			turn = WHITE;
			castling = {w: 0, b: 0};
			ep_square = EMPTY;
			half_moves = 0;
			move_number = 1;
			history = new Array();
			if(!keep_headers)
				header = new Object();
			update_setup(generate_fen());
		}
		
		public function reset():void {
			load(DEFAULT_POSITION);
		}
		
		public function load(fen:String, keep_headers:Boolean = false):Boolean {
			var tokens:Array = fen.split(/\s+/);
			var position:String = tokens[0];
			var square:int = 0;
		
			if (!validate_fen(fen).valid)
				return false;
			
			clear(keep_headers);
		
			for (var i:int = 0; i < position.length; i++) {
				var piece:String = position.charAt(i);
		
				if (piece == '/') {
					square += 8;
				} else if (is_digit(piece)) {
					square += parseInt(piece, 10);
				} else {
					var color = piece < 'a' ? WHITE : BLACK;
					put({type: piece.toLowerCase(), color: color}, algebraic(square));
					square++;
				}
			}
		
			turn = tokens[1];
		
			if (tokens[2].indexOf('K') > -1) {
				castling.w |= BITS.KSIDE_CASTLE;
			}
			if (tokens[2].indexOf('Q') > -1) {
				castling.w |= BITS.QSIDE_CASTLE;
			}
			if (tokens[2].indexOf('k') > -1) {
				castling.b |= BITS.KSIDE_CASTLE;
			}
			if (tokens[2].indexOf('q') > -1) {
				castling.b |= BITS.QSIDE_CASTLE;
			}
		
			ep_square = tokens[3] == '-' ? EMPTY : SQUARES[tokens[3]];
			half_moves = parseInt(tokens[4], 10);
			move_number = parseInt(tokens[5], 10);
		
			update_setup(generate_fen());
		
			return true;
		}
		
		public function validate_fen(fen:String):Object {
			var errors = new Array(
				'No errors.',
				'FEN string must contain six space-delimited fields.',
				'6th field (move number) must be a positive integer.',
				'5th field (half move counter) must be a non-negative integer.',
				'4th field (en-passant square) is invalid.',
				'3rd field (castling availability) is invalid.',
				'2nd field (side to move) is invalid.',
				"1st field (piece positions) does not contain 8 '/'-delimited rows.",
				'1st field (piece positions) is invalid [consecutive numbers].',
				'1st field (piece positions) is invalid [invalid piece].',
				'1st field (piece positions) is invalid [row too large].',
				'Illegal en-passant square'
			);
		
			var tokens:Array = fen.split(/\s+/);
			if (tokens.length !== 6)
				return { valid: false, error_number: 1, error: errors[1] };
			if (isNaN(tokens[5]) || parseInt(tokens[5], 10) <= 0)
				return { valid: false, error_number: 2, error: errors[2] };
			if (isNaN(tokens[4]) || parseInt(tokens[4], 10) < 0)
				return { valid: false, error_number: 3, error: errors[3] };
			if (!/^(-|[abcdefgh][36])$/.test(tokens[3]))
				return { valid: false, error_number: 4, error: errors[4] };
			if (!/^(KQ?k?q?|Qk?q?|kq?|q|-)$/.test(tokens[2]))
				return { valid: false, error_number: 5, error: errors[5] };
			if (!/^(w|b)$/.test(tokens[1]))
				return { valid: false, error_number: 6, error: errors[6] };
			var rows:Array = tokens[0].split('/');
			if (rows.length !== 8)
				return { valid: false, error_number: 7, error: errors[7] };
			for (var i:int = 0; i < rows.length; i++) {
				var sum_fields:int = 0;
				var previous_was_number:Boolean = false;
		
				for (var k:int = 0; k < rows[i].length; k++) {
					if (!isNaN(rows[i][k])) {
						if (previous_was_number)
							return { valid: false, error_number: 8, error: errors[8] };
						sum_fields += parseInt(rows[i][k], 10);
						previous_was_number = true;
					} else {
						if (!/^[prnbqkPRNBQK]$/.test(rows[i][k])) {
							return { valid: false, error_number: 9, error: errors[9] };
						}
						sum_fields += 1;
						previous_was_number = false;
					}
				}
			  
				if (sum_fields != 8)
					return { valid: false, error_number: 10, error: errors[10] };
			}
		
			if ((tokens[3][1] == '3' && tokens[1] == 'w') || (tokens[3][1] == '6' && tokens[1] == 'b'))
				return { valid: false, error_number: 11, error: errors[11] };
			return { valid: true, error_number: 0, error: errors[0] };
		}
		
		public function generate_fen():String {
			var empty:int = 0;
			var fen:String = '';
			for (var i:int = SQUARES.a8; i <= SQUARES.h1; i++) {
				if (board[i] == null)
					empty++;
				else {
					if (empty > 0) {
						fen += empty;
						empty = 0;
					}
					var color:String = board[i].color;
					var piece:String = board[i].type;
					fen += color == WHITE ? piece.toUpperCase() : piece.toLowerCase();
				}
				if ((i + 1) & 0x88) {
					if (empty > 0)
						fen += empty;
					if (i !== SQUARES.h1)
						fen += '/';
					empty = 0;
					i += 8;
				}
			}
			var cflags:String = '';
			if (castling[WHITE] & BITS.KSIDE_CASTLE)
				cflags += 'K';
			if (castling[WHITE] & BITS.QSIDE_CASTLE)
				cflags += 'Q';
			if (castling[BLACK] & BITS.KSIDE_CASTLE)
				cflags += 'k';
			if (castling[BLACK] & BITS.QSIDE_CASTLE)
				cflags += 'q';
			cflags = cflags || '-';
			var epflags:String = ep_square == EMPTY ? '-' : algebraic(ep_square);
			return [fen, turn, cflags, epflags, half_moves, move_number].join(' ');
		}
		
		public function set_header(args:Object):Object {
			for (var i = 0; i < args.length; i += 2)
				header[args[i]] = args[i + 1];
			return header;
		}
		
		private function update_setup(fen:String):void {
			if (history.length > 0) return;
			if (fen != DEFAULT_POSITION) {
				header['SetUp'] = '1';
				header['FEN'] = fen;
			} else {
				header['SetUp'] = null;
				header['FEN'] = null;
			}
		}
		
		public function getSquare(square:String):Object {
			var piece:Object = board[SQUARES[square]];
			return piece != null ? { type: piece.type, color: piece.color } : null;
		}
		
		public function put(piece:Object, square:String):Boolean {
			if (SYMBOLS.indexOf(piece.type.toLowerCase()) === -1)
				return false;
			if (!(square in SQUARES))
				return false;
			var sq:int = SQUARES[square];
			if (piece.type == KING && !(kings[piece.color] == EMPTY || kings[piece.color] == sq))
				return false;
			board[sq] = { type: piece.type, color: piece.color };
			if (piece.type === KING)
				kings[piece.color] = sq;
			update_setup(generate_fen());
			return true;
		}
		
		private function build_move(board:Array, from:String, to:String, flags:int, promotion:int):Object {
			var move:Object = {
				color: turn,
				from: from,
				to: to,
				flags: flags,
				piece: board[from].type
			};
			if (promotion) {
				move.flags |= BITS.PROMOTION;
				move.promotion = promotion;
			}
			if (board[to])
				move.captured = board[to].type;
			else if (flags & BITS.EP_CAPTURE)
				move.captured = PAWN;
			return move;
		}
		
		private function generate_moves(options:Object):Array {
			function add_move(board:Object, moves:Array, from:String, to:String, flags:int) {
				if (board[from].type === PAWN && (rank(to) === RANK_8 || rank(to) === RANK_1)) {
					var pieces:Array = new Array(QUEEN, ROOK, BISHOP, KNIGHT);
					var i:int = 0;
					var len:int = pieces.length;
					for (; i < len; i++)
						moves.push(build_move(board, from, to, flags, pieces[i]));
				} else
					moves.push(build_move(board, from, to, flags));
			}
			var moves:Array = new Array();
			var us:String = turn;
			var them:String = swap_color(us);
			var second_rank:Object = { b: RANK_7, w: RANK_2 };
			var first_sq:int = SQUARES.a8;
			var last_sq:int = SQUARES.h1;
			var single_square:Boolean = false;
			var legal:Boolean = options.legal;
			if (options.square >= 0 || options.square < 0) {
				if (options.square in SQUARES) {
					first_sq = last_sq = SQUARES[options.square];
					single_square = true;
				} else {
					return new Array();
				}
			}
			for (var i:int = first_sq; i <= last_sq; i++) {
				if (i & 0x88) {
					i += 7;
					continue;
				}
				var piece:String = board[i];
				if (piece == null || piece.color != us)
					continue;
				if (piece.type == PAWN) {
					var square:int = i + PAWN_OFFSETS[us][0];
					if (board[square] == null) {
						add_move(board, moves, i, square, BITS.NORMAL);
						var square:int = i + PAWN_OFFSETS[us][1];
						if (second_rank[us] == rank(i) && board[square] == null)
							add_move(board, moves, i, square, BITS.BIG_PAWN);
					}
					for (j = 2; j < 4; j++) {
						var square:int = i + PAWN_OFFSETS[us][j];
						if (square & 0x88) continue;
						if (board[square] != null && board[square].color == them)
							add_move(board, moves, i, square, BITS.CAPTURE);
						else if (square == ep_square)
							add_move(board, moves, i, ep_square, BITS.EP_CAPTURE);
					}
				} else {
					for (var j:int = 0, len = PIECE_OFFSETS[piece.type].length; j < len; j++) {
						var offset:int = PIECE_OFFSETS[piece.type][j];
						var square:int = i;
						while (true) {
							square += offset;
							if (square & 0x88) break;
							if (board[square] == null)
								add_move(board, moves, i, square, BITS.NORMAL);
							else {
								if (board[square].color === us) break;
								add_move(board, moves, i, square, BITS.CAPTURE);
								break;
							}
							if (piece.type === 'n' || piece.type === 'k') break;
						}
					}
				}
			}
			if (!single_square || last_sq === kings[us]) {
				if (castling[us] & BITS.KSIDE_CASTLE) {
					var castling_from:int = kings[us];
					var castling_to:int = castling_from + 2;
					if (board[castling_from + 1] == null && board[castling_to] == null && !attacked(them, kings[us]) && !attacked(them, castling_from + 1) && !attacked(them, castling_to))
						add_move(board, moves, kings[us], castling_to, BITS.KSIDE_CASTLE);
				}
				if (castling[us] & BITS.QSIDE_CASTLE) {
					var castling_from:int = kings[us];
					var castling_to:int = castling_from - 2;
					if (board[castling_from - 1] == null && board[castling_from - 2] == null && board[castling_from - 3] == null && !attacked(them, kings[us]) && !attacked(them, castling_from - 1) && !attacked(them, castling_to))
						add_move(board, moves, kings[us], castling_to, BITS.QSIDE_CASTLE);
				}
			}
			if (!legal)
				return moves;
			var legal_moves:Array = new Array();
			for (var i:int = 0, len = moves.length; i < len; i++) {
				make_move(moves[i]);
				if (!king_attacked(us))
					legal_moves.push(moves[i]);
				undo_move();
			}
			return legal_moves;
		}
		
		private function move_to_san(move:Object, sloppy:Boolean):String {
			var output:String = '';
			if (move.flags & BITS.KSIDE_CASTLE)
				output = 'O-O';
			else if (move.flags & BITS.QSIDE_CASTLE)
				output = 'O-O-O';
			else {
				var disambiguator = get_disambiguator(move, sloppy);
				if (move.piece !== PAWN)
					output += move.piece.toUpperCase() + disambiguator;
				if (move.flags & (BITS.CAPTURE | BITS.EP_CAPTURE)) {
					if (move.piece === PAWN)
						output += algebraic(move.from)[0];
					output += 'x';
				}
				output += algebraic(move.to);
				if (move.flags & BITS.PROMOTION)
					output += '=' + move.promotion.toUpperCase();
			}
			make_move(move);
			if (in_check()) {
				if (in_checkmate())
					output += '#';
		
				else
					output += '+';
			}
			undo_move();
			return output;
		}
		
		private function stripped_san(move:String):String {
			return move.replace(/=/, '').replace(/[+#]?[?!]*$/, '');
		}
		
		private function attacked(color:String, square:int):Boolean {
			for (var i:int = SQUARES.a8; i <= SQUARES.h1; i++) {
				if (i & 0x88) {
					i += 7;
					continue;
				}
				if (board[i] == null || board[i].color != color) continue;
				var piece:Object = board[i];
				var difference:int = i - square;
				var index:int = difference + 119;
				if (ATTACKS[index] & (1 << SHIFTS[piece.type])) {
					if (piece.type == PAWN) {
						if (difference > 0) {
							if (piece.color == WHITE)
								return true;
						} else {
							if (piece.color == BLACK)
								return true;
						}
						continue;
					}
					if (piece.type === 'n' || piece.type === 'k')
						return true;
					var offset:int = RAYS[index];
					var j:int = i + offset;
					var blocked:Boolean = false;
					while (j != square) {
						if (board[j] != null) {
							blocked = true;
							break;
						}
						j += offset;
					}
					if (!blocked)
						return true;
				}
			}
			return false;
		}
		
		private function king_attacked(color:String):Boolean {
			return attacked(swap_color(color), kings[color]);
		}
		
		public function in_check():Boolean {
			return king_attacked(turn);
		}
		
		public function in_checkmate():Boolean {
			return in_check() && generate_moves().length === 0;
		}
		
		public function in_stalemate():Boolean {
			return !in_check() && generate_moves().length === 0;
		}
		
		public function in_draw():Boolean {
			return (
                   half_moves >= 100 ||
                   in_stalemate() ||
                   insufficient_material() ||
                   in_threefold_repetition()
            );
		}
		
		public function game_over():Boolean {
			 return (
                   half_moves >= 100 ||
                   in_checkmate() ||
                   in_stalemate() ||
                   insufficient_material() ||
                   in_threefold_repetition()
             );
		}
		
		public function insufficient_material():Boolean {
			var pieces:Object = new Object();
			var bishops:Array = new Array();
			var num_pieces:int = 0;
			var sq_color:int = 0;
			for (var i:int = SQUARES.a8; i <= SQUARES.h1; i++) {
				sq_color = (sq_color + 1) % 2;
				if (i & 0x88) {
					i += 7;
					continue;
				}
				var piece:Object = board[i];
				if (piece) {
					pieces[piece.type] = piece.type in pieces ? pieces[piece.type] + 1 : 1;
					if (piece.type === BISHOP)
						bishops.push(sq_color);
					num_pieces++;
				}
			}
			
			if (num_pieces == 2)
				return true;
			else if (num_pieces == 3 && (pieces[BISHOP] == 1 || pieces[KNIGHT] == 1))
				return true;
			else if (num_pieces === pieces[BISHOP] + 2) {
				var sum:int = 0;
				var len:int = bishops.length;
				for (var i:int = 0; i < len; i++)
					sum += bishops[i];
				if (sum == 0 || sum == len)
					return true;
			}
			return false;
		}
		
		public function in_threefold_repetition():Boolean {
			var moves:Array = new Array();
			var positions:Object = new Object();
			var repetition:Boolean = false;
			while (true) {
				var move = undo_move();
				if (!move) break;
				moves.push(move);
			}
			while (true) {
				var fen:String = generate_fen() .split(' ').slice(0, 4).join(' ');
				positions[fen] = fen in positions ? positions[fen] + 1 : 1;
				if (positions[fen] >= 3)
					repetition = true;
				if (!moves.length)
					break;
				make_move(moves.pop());
			}
			return repetition;
		}
		
		private function push(move:String):void {
			history.push({
				move: move,
				kings: { b: kings.b, w: kings.w },
				turn: turn,
				castling: { b: castling.b, w: castling.w },
				ep_square: ep_square,
				half_moves: half_moves,
				move_number: move_number
			});
		}
		
		private function make_move(move:String):void {
			var us:String = turn;
			var them:String = swap_color(us);
			push(move);
			board[move.to] = board[move.from];
			board[move.from] = null;
			if (move.flags & BITS.EP_CAPTURE) {
				if (turn == BLACK)
					board[move.to - 16] = null;
				else
					board[move.to + 16] = null;
			}
			if (move.flags & BITS.PROMOTION)
				board[move.to] = { type: move.promotion, color: us };
			if (board[move.to].type == KING) {
				kings[board[move.to].color] = move.to;
				if (move.flags & BITS.KSIDE_CASTLE) {
					var castling_to:int = move.to - 1;
					var castling_from:int = move.to + 1;
					board[castling_to] = board[castling_from];
					board[castling_from] = null;
				} else if (move.flags & BITS.QSIDE_CASTLE) {
					var castling_to:int = move.to + 1;
					var castling_from:int = move.to - 2;
					board[castling_to] = board[castling_from];
					board[castling_from] = null;
				}
				castling[us] = '';
			}
			if (castling[us]) {
				for (var i:int = 0, len:int = ROOKS[us].length; i < len; i++) {
					if (move.from === ROOKS[us][i].square && castling[us] & ROOKS[us][i].flag) {
						castling[us] ^= ROOKS[us][i].flag;
						break;
					}
				}
			}
			if (castling[them]) {
				for (var i:int = 0, len:int = ROOKS[them].length; i < len; i++) {
					if (move.to == ROOKS[them][i].square && castling[them] & ROOKS[them][i].flag) {
						castling[them] ^= ROOKS[them][i].flag;
						break;
					}
				}
			}
			if (move.flags & BITS.BIG_PAWN) {
				if (turn == 'b')
					ep_square = move.to - 16;
				else
					ep_square = move.to + 16;
			} else
				ep_square = EMPTY;
			if (move.piece == PAWN)
				half_moves = 0;
			else if (move.flags & (BITS.CAPTURE | BITS.EP_CAPTURE))
				half_moves = 0;
			else
				half_moves++;
			if (turn === BLACK)
				move_number++;
			turn = swap_color(turn);
		}
		
		private function undo_move():String {
			var old:Object = history.pop();
			if (old == null)
				return null;
			var move:String = old.move;
			kings = old.kings;
			turn = old.turn;
			castling = old.castling;
			ep_square = old.ep_square;
			half_moves = old.half_moves;
			move_number = old.move_number;
			var us:String = turn;
			var them:String = swap_color(turn);
			board[move.from] = board[move.to];
			board[move.from].type = move.piece;
			board[move.to] = null;
			if (move.flags & BITS.CAPTURE) {
				board[move.to] = { type: move.captured, color: them };
			} else if (move.flags & BITS.EP_CAPTURE) {
				var index:int;
				if (us == BLACK)
					index = move.to - 16;
				else
					index = move.to + 16;
				board[index] = { type: PAWN, color: them };
			}
			if (move.flags & (BITS.KSIDE_CASTLE | BITS.QSIDE_CASTLE)) {
				var castling_to, castling_from;
				if (move.flags & BITS.KSIDE_CASTLE) {
					castling_to = move.to + 1;
					castling_from = move.to - 1;
				} else if (move.flags & BITS.QSIDE_CASTLE) {
					castling_to = move.to - 2;
					castling_from = move.to + 1;
				}
				board[castling_to] = board[castling_from];
				board[castling_from] = null;
			}
			return move;
		}
		
		private function get_disambiguator(move:Object, sloppy:Boolean):String {
			var moves:Array = generate_moves({ legal: !sloppy });
			var from:String = move.from;
			var to:String = move.to;
			var piece:Object = move.piece;
			var ambiguities:int = 0;
			var same_rank:int = 0;
			var same_file:int = 0;
			for (var i:int = 0, len:int = moves.length; i < len; i++) {
				var ambig_from:String = moves[i].from;
				var ambig_to:String = moves[i].to;
				var ambig_piece:Object = moves[i].piece;
				if (piece === ambig_piece && from !== ambig_from && to === ambig_to) {
					ambiguities++;
					if (rank(from) === rank(ambig_from))
						same_rank++;
					if (file(from) === file(ambig_from))
						same_file++;
				}
			}
			if (ambiguities > 0) {
				if (same_rank > 0 && same_file > 0)
					return algebraic(from);
				else if (same_file > 0) {
					return algebraic(from).charAt(1);
				} else {
					/* else use the file symbol */
					return algebraic(from).charAt(0);
				}
			}
			return '';
		}
		
		public function ascii():String {
			var s:String = '   +------------------------+\n';
			for (var i:int = SQUARES.a8; i <= SQUARES.h1; i++) {
				if (file(i) === 0)
					s += ' ' + '87654321'[rank(i)] + ' |';
				if (board[i] == null)
					s += ' . ';
		
				else {
					var piece = board[i].type;
					var color = board[i].color;
					var symbol = color == WHITE ? piece.toUpperCase() : piece.toLowerCase();
					s += ' ' + symbol + ' ';
				}
				if ((i + 1) & 0x88) {
					s += '|\n';
					i += 8;
				}
			}
			s += '   +------------------------+\n';
			s += '     a  b  c  d  e  f  g  h\n';
			return s;
		}
		
		private function move_from_san(move:Object, sloppy:Boolean):Object {
			var clean_move:String = stripped_san(move);
			if (sloppy) {
				var matches:Array = clean_move.match(/([pnbrqkPNBRQK])?([a-h][1-8])x?-?([a-h][1-8])([qrbnQRBN])?/);
				if (matches) {
					var piece:Object = matches[1];
					var from:String = matches[2];
					var to:String = matches[3];
					var promotion:int = matches[4];
				}
			}
			var moves:Array = generate_moves();
			for (var i:int = 0, len = moves.length; i < len; i++) {
				if (clean_move == stripped_san(move_to_san(moves[i])) || (sloppy && clean_move == stripped_san(move_to_san(moves[i], true))))
					return moves[i];
				else {
					if (
						matches &&
						(!piece || piece.toLowerCase() == moves[i].piece) &&
						SQUARES[from] == moves[i].from &&
						SQUARES[to] == moves[i].to &&
						(!promotion || promotion.toLowerCase() == moves[i].promotion)
					)
						return moves[i];
				}
			}
			return null;
		}
		
		private function rank(i:int):int {
			return i >> 4;
		}
		
		private function file(i:int):int {
			return i & 15;
		}
		
		private function algebraic(i:int):String {
			var f:int = file(i), r:int = rank(i);
			return 'abcdefgh'.substring(f, f + 1) + '87654321'.substring(r, r + 1);
		}
		
		private function swap_color(c:String):String {
			return c == WHITE ? BLACK : WHITE;
		}
		
		private function is_digit(c:String):Boolean {
			return '0123456789'.indexOf(c) != -1;
		}
		
		private function make_pretty(ugly_move:Object):Object {
			var move = clone(ugly_move);
			move.san = move_to_san(move, false);
			move.to = algebraic(move.to);
			move.from = algebraic(move.from);
			var flags:String = '';
			for (var flag:int in BITS) {
				if (BITS[flag] & move.flags)
					flags += FLAGS[flag];
			}
			move.flags = flags;
			return move;
		}
		
		private function clone(obj:Object):Object {
			var dupe = obj instanceof Array ? new Array() : new Object();
			for (var property:String in obj) {
				if (typeof property == 'object')
					dupe[property] = clone(obj[property]);
				else
					dupe[property] = obj[property];
			}
			return dupe;
		}
		
		private function trim(str:String):String {
			return str.replace(/^\s+|\s+$/g, '');
		}
		
		public function ChessEngine(fen:String = null) {
			if(fen == null) {
				load(DEFAULT_POSITION);
			} else load(fen);
		}
		
		public function moves(options:Object):Array {
			var ugly_moves:Object = generate_moves(options);
			var moves:Array = new Array();
			for (var i:int = 0, len:int = ugly_moves.length; i < len; i++)
				moves.push(move_to_san(ugly_moves[i], false));
			return moves;
		}
		
		public function getBoard():Array {
			var output:Array = new Array(), row:Array = new Array();
			for (var i:int = SQUARES.a8; i <= SQUARES.h1; i++) {
				if (board[i] == null)
					row.push(null);
				else
					row.push({ type: board[i].type, color: board[i].color });
				if ((i + 1) & 0x88) {
					output.push(row);
					row = new Array();
					i += 8;
				}
			}
			return output;
		}
		
		public function pgn():String {
			var newline:String = '\n';
			var max_width:int = 80;
			var result:Array = new Array();
			var header_exists:Boolean = false;
			for (var i:String in header) {
				result.push('[' + i + ' "' + header[i] + '"]' + newline);
				header_exists = true;
			}
			if (header_exists && history.length)
				result.push(newline);
			var reversed_history:Array = new Array();
			while (history.length > 0)
				reversed_history.push(undo_move());
			var moves:Array = new Array();
			var move_string:String = '';
			while (reversed_history.length > 0) {
				var move:Object = reversed_history.pop();
				if (!history.length && move.color === 'b')
					move_string = move_number + '. ...';
				else if (move.color === 'w') {
					if (move_string.length)
						moves.push(move_string);
					move_string = move_number + '.';
				}
				move_string = move_string + ' ' + move_to_san(move, false);
				make_move(move);
			}
			if (move_string.length)
				moves.push(move_string);
			if (header.Result != undefined)
				moves.push(header.Result);
			if (max_width === 0)
				return result.join('') + moves.join(' ');
			var current_width:int = 0;
			for (var it:int = 0; it < moves.length; it++) {
				if (current_width + moves[it].length > max_width && it != 0) {
					if (result[result.length - 1] === ' ')
						result.pop();
					result.push(newline);
					current_width = 0;
				} else if (it != 0) {
					result.push(' ');
					current_width++;
				}
				result.push(moves[it]);
				current_width += moves[it].length;
			}
			return result.join('');
		}
		
		public function load_pgn(pgn:String):Boolean {
			function mask(str:String):String {
				return str.replace(/\\/g, '\\');
			}
			
			function has_keys(object:Object):Boolean {
				for (var key in object)
					return true;
				return false;
			}
			
			function parse_pgn_header(header:String):Object {
				var newline_char ='\r?\n';
				var header_obj = {};
				var headers = header.split(new RegExp(mask(newline_char)));
				var key = '';
				var value = '';
				for (var i = 0; i < headers.length; i++) {
					key = headers[i].replace(/^\[([A-Z][A-Za-z] *)\s.*\]$/, '$1');
					value = headers[i].replace(/^\[[A-Za-z]+\s"(.*)"\]$/, '$1');
					if (trim(key).length > 0)
						header_obj[key] = value;
				}
				return header_obj;
			}
			
			var newline_char:String = '\r?\n';
			var header_regex:RegExp = new RegExp('^(\\[((?:' + mask(newline_char) + ')|.)*\\])' + '(?:' + mask(newline_char) + '){2}');
			var header_string:String = header_regex.test(pgn) ? header_regex.exec(pgn)[1] : '';
			reset();
			var headers:Object = parse_pgn_header(header_string);
			for (var key:String in headers)
				set_header([key, headers[key]]);
			if (headers['SetUp'] === '1')
				if (!('FEN' in headers && load(headers['FEN'], true)))
					return false;
			var ms:String = pgn.replace(header_string, '').replace(new RegExp(mask(newline_char), 'g'), ' ');
			ms = ms.replace(/(\ {[^}]+\})+?/g, '');
			var rav_regex:RegExp = /(\([^\(\)]+\))+?/g;
			while (rav_regex.test(ms))
			ms = ms.replace(rav_regex, '');
			ms = ms.replace(/\d+\.(\.\.)?/g, '');
			ms = ms.replace(/\.\.\./g, '');
			ms = ms.replace(/\$\d+/g, '');
		
			var moves:Array = trim(ms).split(new RegExp(/\s+/));
		
			moves = moves.join(',').replace(/,,+/g, ',').split(',');
			
			var move:String = '';
		
			for (var half_move:int = 0; half_move < moves.length - 1; half_move++) {
				move = move_from_san(moves[half_move], sloppy);
				if (move == null)
					return false;
				else
					make_move(move);
			}
		
			move = moves[moves.length - 1];
			if (POSSIBLE_RESULTS.indexOf(move) > -1)
				if (has_keys(header) && header.Result == undefined)
						set_header(['Result', move]);
			else {
				move = move_from_san(move, sloppy);
				if (move == null)
					return false;
				else
					make_move(move);
			}
			return true;
		}
		
		public function move(mov:*):Object {
			var sloppy:Boolean = false;
			var move_obj:Object = null;
			if (typeof mov == 'string')
				move_obj = move_from_san(mov, sloppy);
		
			else if (typeof mov == 'object') {
				var moves = generate_moves();
				for (var i:int = 0, len:int = moves.length; i < len; i++)
					if (mov.from == algebraic(moves[i].from) && mov.to == algebraic(moves[i].to) && (!('promotion' in moves[i]) ||  mov.promotion == moves[i].promotion)) {
						move_obj = moves[i];
						break;
					}
			}
			if (!move_obj)
				return null;
			var pretty_move:Object = make_pretty(move_obj);
			make_move(move_obj);
			return pretty_move;
		}
		
		public function undo():Object {
			var move = undo_move();
			return move ? make_pretty(move) : null;
		}
		
		public function remove(square:String):Object {
    		var piece:Object = getSquare(square);
    		board[SQUARES[square]] = null;
    		if (piece && piece.type == KING) {
      			kings[piece.color] = EMPTY;
    		}
    		update_setup(generate_fen());
    		return piece;
		}
		
		public function square_color(square:String):String {
			if (square in SQUARES) {
				var sq_0x88:int = SQUARES[square];
				return (rank(sq_0x88) + file(sq_0x88)) % 2 === 0 ? 'light' : 'dark';
			}
			return null;
		}
		
		public function getHistory():Array {
			var reversed_history:Array = new Array();
			var move_history:Array = new Array();
			while (history.length > 0)
				reversed_history.push(undo_move());
			while (reversed_history.length > 0) {
				var move:Object = reversed_history.pop();
				move_history.push(move_to_san(move));
				make_move(move);
			}
			return move_history;
		}
	}
}
