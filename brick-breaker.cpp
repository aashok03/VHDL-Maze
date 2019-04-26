#include <algorithm> // fill_n()
#include <cmath>    // abs(), min(), max()
#include <iostream> // IO

/* 32 x 8 */
struct State {
        static const int PIXEL = 32; // size of pixel
        static const int BRICK = 32 * PIXEL;
        
        static const int WIDTH  = 512 * PIXEL; // 16 blocks
        static const int HEIGHT = 480 * PIXEL; // 15 blocks
        
        static const int PADDLE_WIDTH = 80 * PIXEL;
        static const int PADDLE_SPEED = 50 * PIXEL; // CHANGE THIS
                        
        static const int BRICK_ROWS = 5;
        static const int BRICK_COLS = 16;
        static const int BRICK_NUM  = BRICK_ROWS * BRICK_COLS;

        static_assert(WIDTH/BRICK_COLS == BRICK, "INVARIANT INVALID");
        
        bool bricks[BRICK_NUM];
        int paddle;
        int ball_p[2];
        int ball_v[2];

        void reset() {
                std::fill_n(bricks, BRICK_NUM, false);
                paddle = WIDTH/2;
                ball_p[0] = 3*WIDTH/4;
                ball_p[1] = HEIGHT-1;
                ball_v[0] =  BRICK; // CHANGE THIS
                ball_v[1] = -BRICK; // CHANGE THIS
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

                // for (int i = 0; i < BRICK_ROWS * BRICK_COLS; ++i) {

                //         // constructing brick intervals
                //         int x_interval[2];
                //         int y_interval[2];
                        
                //         x_interval[0] = (i % BRICK_COLS) * BRICK_SIZE;
                //         x_interval[1] = x_interval[0] + BRICK_SIZE;

                //         y_interval[0] = (i / BRICK_COLS) * BRICK_SIZE;
                //         y_interval[1] = y_interval[0] + BRICK_SIZE;

                //         std::cerr << "CURRENT BRICK : (" << x_interval[0]/UNIT << '-' << x_interval[1]/UNIT
                //                   << ", " << y_interval[0]/UNIT << '-' << y_interval[1]/UNIT << ")\n";
                        
                        
                //         if (ball_p[0] < x_interval[0] or
                //             ball_p[0] > x_interval[1] or
                //             ball_p[1] < y_interval[0] or
                //             ball_p[1] > y_interval[1])
                //                 continue; // no collision                        
                //         else {
                //                 std::cerr << "BALL IS AT (" << ball_p[0]/UNIT << ", " << ball_p[1]/UNIT << ")\n";
                //                 std::cerr << "BRICK COLLISION AT " << x_interval[0]/UNIT << " and " << y_interval[0]/UNIT << std::endl;
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
                for (int i = 0; i < WIDTH/BRICK; ++i)
                        std::cout << "--";
                std::cout << '\n';

                for (int r = 0; r < HEIGHT/BRICK; ++r) {
                        std::cout << '|';
                        for (int c = 0; c < WIDTH/BRICK; ++c) {
                                if (r < BRICK_ROWS and bricks[(BRICK_ROWS-r-1)*BRICK_COLS+c]) {
                                        std::cout << "x ";
                                } else if (ball_p[0] >= c*BRICK      and
                                          (ball_p[0] < (c+1)*BRICK)  and
                                           ball_p[1] >= r*BRICK      and
                                           ball_p[1] < (r+1)*BRICK)
                                        std::cout << "o ";                                
                                else {
                                        std::cout << "  ";
                                }
                        }
                        std::cout << "|\n";
                }
           
                for (int i = 0; i < WIDTH; i += BRICK) {
                        if (i > paddle and i < paddle+PADDLE_WIDTH)
                                std::cout << "--";
                        else    std::cout << "  ";
                        
                }
                std::cout << '\n';
                std::cout << "PADDLE : " << (float)paddle/BRICK << std::endl;
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
