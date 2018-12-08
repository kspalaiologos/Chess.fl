package {
	public class ChessEngine {
		public var BLACK:String = 'b';
		public var WHITE:String = 'w';
		public var EMPTY:int = -1;
		
		public var PAWN:String = 'p';
		public var KNIGHT:String = 'n';
		public var BISHOP:String = 'b';
		public var ROOK:String = 'r';
		public var QUEEN:String = 'q';
		public var KING:String = 'k';
		public var SYMBOLS:String = 'pnbrqkPNBRQK';
		public var DEFAULT_POSITION:String = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
		public var POSSIBLE_RESULTS:Array = new Array('1-0', '0-1', '1/2-1/2', '*');
		
		public var PAWN_OFFSETS:Object = {
			b: new Array(16, 32, 17, 15),
			w: new Array(-16, -32, -17, -15)
		};
		
		public var PIECE_OFFSETS:Object = {
			n: new Array(-18, -33, -31, -14, 18, 33, 31, 14),
			b: new Array(-17, -15, 17, 15),
			r: new Array(-16, 1, 16, -1),
			q: new Array(-17, -16, -15, 1, 17, 16, 15, -1),
			k: new Array(-17, -16, -15, 1, 17, 16, 15, -1)
		};
		
		public var ATTACKS:Array = new Array(
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
		
		public var RAYS:Array = new Array(
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
		
		public var SHIFTS:Object = {
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
		
		public var BITS:Object = {
			NORMAL: 1,
			CAPTURE: 2,
			BIG_PAWN: 4,
			EP_CAPTURE: 8,
			PROMOTION: 16,
			KSIDE_CASTLE: 32,
			QSIDE_CASTLE: 64
		};
		
		public var RANK_1:int = 7;
		public var RANK_2:int = 6;
		public var RANK_3:int = 5;
		public var RANK_4:int = 4;
		public var RANK_5:int = 3;
		public var RANK_6:int = 2;
		public var RANK_7:int = 1;
		public var RANK_8:int = 0;
		
		public var SQUARES:Object = {
			a8:	  0, b8:   1, c8:	2, d8:	 3, e8:	  4, f8:   5, g8:	6, h8:	 7,
			a7:	 16, b7:  17, c7:  18, d7:	19, e7:	 20, f7:  21, g7:  22, h7:	23,
			a6:	 32, b6:  33, c6:  34, d6:	35, e6:	 36, f6:  37, g6:  38, h6:	39,
			a5:	 48, b5:  49, c5:  50, d5:	51, e5:	 52, f5:  53, g5:  54, h5:	55,
			a4:	 64, b4:  65, c4:  66, d4:	67, e4:	 68, f4:  69, g4:  70, h4:	71,
			a3:	 80, b3:  81, c3:  82, d3:	83, e3:	 84, f3:  85, g3:  86, h3:	87,
			a2:	 96, b2:  97, c2:  98, d2:	99, e2: 100, f2: 101, g2: 102, h2: 103,
			a1: 112, b1: 113, c1: 114, d1: 115, e1: 116, f1: 117, g1: 118, h1: 119
		};
		
		public var ROOKS:Object = {
			w: new Array(
				{square: SQUARES.a1, flag: BITS.QSIDE_CASTLE},
				{square: SQUARES.h1, flag: BITS.KSIDE_CASTLE}
			),
			b: new Array(
				{square: SQUARES.a8, flag: BITS.QSIDE_CASTLE},
				{square: SQUARES.h8, flag: BITS.KSIDE_CASTLE}
			)
		};
		
		public var board:Array = new Array();
		
		public var kings:Object = {
			w: EMPTY,
			b: EMPTY
		};
		
		public var turn:String = WHITE;
		
		public var castling:Object = {
			w: 0,
			b: 0
		};
		
		public var ep_square:int = EMPTY;
		public var half_moves:int = 0;
		public var move_number:int = 1;
		public var history:Array = new Array();
		public var header:Object = new Object();
		
		public function ChessEngine(fen:String = null) {
			if(fen == null) {
				load(DEFAULT_POSITION);
			} else load(fen);
		}
		
		public function clear(keep_headers:Boolean = false):void {
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
		
		public function update_setup(fen:String):void {
			if (history.length > 0) return;
			if (fen != DEFAULT_POSITION) {
				header['SetUp'] = '1';
				header['FEN'] = fen;
			} else {
				header['SetUp'] = null;
				header['FEN'] = null;
			}
		}
		
		public function get(square:String):Object {
			var piece:int = board[SQUARES[square]];
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
		
		public function build_move(board:Array, from:String, to:String, flags:int, promotion:int):Object {
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
		
		public function generate_moves(options:Object):Array {
			function add_move(board:Object, moves:Array, from:String, to:String, flags:int) {
				if (board[from].type === PAWN && (rank(to) === RANK_8 || rank(to) === RANK_1)) {
					var pieces:Array = new Array(QUEEN, ROOK, BISHOP, KNIGHT);
					for (var i = 0:int, len:int = pieces.length; i < len; i++)
						moves.push(build_move(board, from, to, flags, pieces[i]));
				} else
					moves.push(build_move(board, from, to, flags));
			}
			var moves:Array = new Array();
			var us:int = turn;
			var them:int = swap_color(us);
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
				var piece:int = board[i];
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
		
		public function move_to_san(move:Object, sloppy:Boolean):String {
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
		
		public function stripped_san(move:String):String {
			return move.replace(/=/, '').replace(/[+#]?[?!]*$/, '');
		}
		
		public function attacked(color:String, square:int):Boolean {
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
		
		public function king_attacked(color:String):Boolean {
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
		
		public function push(move:String):void {
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
		
		public function make_move(move:String):void {
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
		
		public function undo_move():String {
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
	}
}
