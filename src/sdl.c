#include <SDL3/SDL.h>
#include <SDL3/SDL_main.h>

int main() {
  SDL_Init(SDL_INIT_VIDEO);

  SDL_Window* window = SDL_CreateWindow("test", 640, 480, SDL_WINDOW_OPENGL);

  int done = 0;
  while(done == 0) {
    SDL_Event event;

    while (SDL_PollEvent(&event)) {
      if (event.type == SDL_EVENT_QUIT) {
        done = 1;
      }
    }
  }


  SDL_DestroyWindow(window);
  SDL_Quit();

  return 0;
}
