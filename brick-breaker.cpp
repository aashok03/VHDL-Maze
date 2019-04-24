#include <algorithm> // fill_n()
#include <cmath>    // abs(), min(), max()
#include <iostream> // IO

/* 32 x 8 */
struct State {
        static const int UNIT = 1024;
        
        static const int WIDTH  = 32 * UNIT;
        static const int HEIGHT = 16 * UNIT;
        
        static const int PADDLE_WIDTH = UNIT*4;
        static const int PADDLE_SPEED = UNIT/2;
                        
        static const int BRICK_ROWS = 8;
        static const int BRICK_COLS = 32;
        static const int BRICK_SIZE = WIDTH/BRICK_ROWS;
        static const int BRICK_MIN_HEIGHT = HEIGHT/2;
        
        bool bricks[BRICK_ROWS * BRICK_COLS];
        int paddle;
        int ball_p[2];
        int ball_v[2];

        void reset() {
                std::fill_n(bricks, BRICK_ROWS*BRICK_COLS, true);
                paddle = WIDTH/2;
                ball_p[0] = WIDTH/2;
                ball_p[1] = HEIGHT-1;
                ball_v[0] = UNIT;
                ball_v[1] = -UNIT;
        }
        State() { reset(); }

#define MAX(x,y) x < y ? y : x; // y if x < y
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
                if (ball_p[0] < 0 or ball_p[0] > WIDTH)
                        ball_v[0] = -ball_v[0]; 

                // top collision
                if (ball_p[1] <= 0)
                        ball_v[1] = -ball_v[1];

                // bottom collision
                if (ball_p[1] >= HEIGHT) {
                        if (ball_p[0] >= paddle and
                            ball_p[0] <= paddle + PADDLE_WIDTH)
                                ball_v[1] = -ball_v[1];
                        else {
                                reset(); // game over
                                return;
                        }                        
                }

                for (int i = 0; i < BRICK_ROWS * BRICK_COLS; ++i) {

                        // constructing brick intervals
                        int x_interval[2];
                        int y_interval[2];

                        x_interval[0] = (i % BRICK_COLS) * BRICK_SIZE;
                        x_interval[1] = x_interval[0] + BRICK_SIZE;

                        y_interval[0] = (i / BRICK_COLS) * BRICK_SIZE + BRICK_MIN_HEIGHT;
                        y_interval[1] = y_interval[0] + BRICK_SIZE;

                        if (ball_p[0] < x_interval[0] or
                            ball_p[0] > x_interval[1] or
                            ball_p[1] < y_interval[0] or
                            ball_p[1] > y_interval[1])
                                continue; // no collision
                        
                        else {
                                bricks[i] = false;

                                // center of block
                                int center[2] = { (x_interval[0]+x_interval[1])/2,
                                                  (y_interval[0]+y_interval[1])/2 };

                                // distance of ball from center of block
                                int distance[2] = { std::abs(center[0]-ball_p[0]),
                                                    std::abs(center[1]-ball_p[1]) };

                                if (distance[0] > distance[1]) 
                                        ball_v[1] = -ball_v[1];
                                else    ball_v[0] = -ball_v[0];
                        }
                }
        }

        void render() { // DISCARD THIS -- WILL BE REPLACED BY VGA

                std::cout << "POSITION : " << ball_p[0]/UNIT << ", " << ball_p[1]/UNIT << std::endl;
                for (int i = 0; i < WIDTH/UNIT; ++i)
                        std::cout << "--";
                std::cout << '\n';

                for (int r = 0; r < HEIGHT/UNIT; ++r) {
                        std::cout << '|';
                        for (int c = 0; c < WIDTH/UNIT; ++c) {
                                
                                if (r < 8 and bricks[(BRICK_ROWS-r-1)*BRICK_COLS+c]) {
                                        std::cout << "x ";
                                } else if (ball_p[0] >= c*UNIT      and
                                          (ball_p[0] < (c+1)*UNIT)  and
                                           ball_p[1] >= r*UNIT      and
                                           ball_p[1] < (r+1)*UNIT)
                                        std::cout << "o ";                                
                                else {
                                        std::cout << "  ";
                                }
                        }
                        std::cout << "|\n";
                }

                for (int i = 0; i < WIDTH/UNIT; ++i) {
                        if (i * UNIT > paddle and i*UNIT < paddle+WIDTH)
                                std::cout << "--";
                        else  {
                                std::cout << "  ";
                        }
                            }
                std::cout << '\n';
                std::cout << "PADDLE : " << (float)paddle/UNIT << std::endl;
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
