#include <algorithm> // fill_n()
#include <cmath>    // abs(), min(), max()
#include <iostream> // IO

/* 32 x 8 */
struct State {
        static const int PIXEL = 512; // size of pixel
        static const int BLOCK = 32 * PIXEL;
        
        static const int WIDTH  = 512 * PIXEL; // 16 blocks
        static const int HEIGHT = 480 * PIXEL; // 15 blocks
        
        static const int PADDLE_WIDTH = 50 * PIXEL;
        static const int PADDLE_SPEED = 50 * PIXEL; // CHANGE THIS
                        
        static const int BLOCK_ROWS = 5;
        static const int BLOCK_COLS = 16;
        static const int BLOCK_NUM  = BLOCK_ROWS * BLOCK_COLS;

        static_assert(WIDTH/BLOCK_COLS == BLOCK, "INVARIANT INVALID");
        
        bool bricks[BLOCK_NUM];
        int paddle;
        int ball_p[2];
        int ball_v[2];

        void reset() {
                std::fill_n(bricks, BLOCK_NUM, false);
                paddle = WIDTH/2;
                ball_p[0] = 3*WIDTH/4;
                ball_p[1] = HEIGHT-1;
                ball_v[0] =  BLOCK; // CHANGE THIS
                ball_v[1] = -BLOCK; // CHANGE THIS
        }
        State() { reset(); }

        void update(int input) { // -1 => LEFT, 1 => RIGHT, 0 => WAIT
                
                // player move
                if (input == -1)
                        paddle = std::max(paddle-PADDLE_SPEED, 0);
                if (input == 1)
                        paddle = std::min(paddle+PADDLE_SPEED, WIDTH-PADDLE_WIDTH);
                
                // updating position
                ball_p[0] += ball_v[0];
                ball_p[1] += ball_v[1];
                
                // horizontal collision
                if (ball_p[0] <= 0 or ball_p[0] >= WIDTH) {
                        std::cerr << "HORIZONTAL COLLISIONHORIZONTAL COLLISIONHORIZONTAL COLLISIONHORIZONTAL COLLISION\n";
                        ball_v[0] = -ball_v[0];
                }

                //top collision
                if (ball_p[1] <= 0) {
                        std::cerr << "VERTICAL COLLISION VERTICAL COLLISION VERTICAL COLLISION VERTICAL COLLISION VERTICAL COLLISION \n";
                        ball_v[1] = -ball_v[1];
                }

                // bottom collision
                if (ball_p[1] >= HEIGHT) {
                        if (ball_p[0] >= paddle and
                            ball_p[0] <= paddle + PADDLE_WIDTH) {
                                ball_v[1] = -ball_v[1];
                        }
                        else {
                                assert(false && "END");
                                
                                reset(); // game over
                                return;
                        }                        
                }

                // for (int i = 0; i < BLOCK_ROWS * BLOCK_COLS; ++i) {

                //         // constructing brick intervals
                //         int x_interval[2];
                //         int y_interval[2];
                        
                //         x_interval[0] = (i % BLOCK_COLS) * BLOCK_SIZE;
                //         x_interval[1] = x_interval[0] + BLOCK_SIZE;

                //         y_interval[0] = (i / BLOCK_COLS) * BLOCK_SIZE;
                //         y_interval[1] = y_interval[0] + BLOCK_SIZE;

                //         std::cerr << "CURRENT BLOCK : (" << x_interval[0]/UNIT << '-' << x_interval[1]/UNIT
                //                   << ", " << y_interval[0]/UNIT << '-' << y_interval[1]/UNIT << ")\n";
                        
                        
                //         if (ball_p[0] < x_interval[0] or
                //             ball_p[0] > x_interval[1] or
                //             ball_p[1] < y_interval[0] or
                //             ball_p[1] > y_interval[1])
                //                 continue; // no collision                        
                //         else {
                //                 std::cerr << "BALL IS AT (" << ball_p[0]/UNIT << ", " << ball_p[1]/UNIT << ")\n";
                //                 std::cerr << "BLOCK COLLISION AT " << x_interval[0]/UNIT << " and " << y_interval[0]/UNIT << std::endl;
                //                 bricks[i] = false;

                //                 // center of block
                //                 int center[2] = { (x_interval[0]+x_interval[1])/2,
                //                                   (y_interval[0]+y_interval[1])/2 };

                //                 // distance of ball from center of block
                //                 int distance[2] = { std::abs(center[0]-ball_p[0]),
                //                                     std::abs(center[1]-ball_p[1]) };

                //                 if (distance[0] > distance[1]) 
                //                         ball_v[1] = -ball_v[1];
                //                 else    ball_v[0] = -ball_v[0];
                //         }
                // }
        }

        void render() { // DISCARD THIS -- WILL BE REPLACED BY VGA

                std::cout << "POSITION : " << ball_p[0]/PIXEL << ", " << ball_p[1]/PIXEL << std::endl;
                for (int i = 0; i < WIDTH/BLOCK; ++i)
                        std::cout << "--";
                std::cout << '\n';

                for (int r = 0; r < HEIGHT/BLOCK; ++r) {
                        std::cout << '|';
                        for (int c = 0; c < WIDTH/BLOCK; ++c) {
                                if (r < BLOCK_ROWS and bricks[(BLOCK_ROWS-r-1)*BLOCK_COLS+c]) {
                                        std::cout << "x ";
                                } else if (ball_p[0] >= c*BLOCK      and
                                          (ball_p[0] < (c+1)*BLOCK)  and
                                           ball_p[1] >= r*BLOCK      and
                                           ball_p[1] < (r+1)*BLOCK)
                                        std::cout << "o ";                                
                                else {
                                        std::cout << "  ";
                                }
                        }
                        std::cout << "|\n";
                }
           
                for (int i = 0; i < WIDTH; i += BLOCK) {
                        if (i > paddle and i < paddle+PADDLE_WIDTH)
                                std::cout << "--";
                        else    std::cout << "  ";
                        
                }
                std::cout << '\n';
                std::cout << "PADDLE : " << (float)paddle/BLOCK << std::endl;
        }
};

int main() {
        State state;
        while (1) {
                state.render();
                char i;                
                std::cin >> i;
                int inp;
                if (i == 'a')      inp = -1;
                else if (i == 'd') inp = 1;
                else               inp = 0;
                state.update(inp);
                state.render();
        }
}
