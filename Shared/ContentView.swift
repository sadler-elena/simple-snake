//
//  ContentView.swift
//  Shared
//
//  Created by Elena Sadler on 1/4/21.
//

import SwiftUI

//enum for directions
enum direction {
    case up, down, left, right
}

struct ContentView: View {
    @State var restart_game = false
    //start position for gestures
    @State var start_pos: CGPoint = .zero
    //bool to determine if user started swipe
    @State var is_started = true
    //bool to end game if the snake hits border
    @State var is_over = false
    //direction the snake is going
    @State var snake_dir = direction.down
    //array of CGPoints for snake's body position
    @State var pos_array = [CGPoint(x: 0, y: 0)]
    //position for food
    @State var food_pos = CGPoint(x: 0, y: 0)
    //score
    @State var score: Int = 0

    
    //width/height of snake
    let snake_size: CGFloat = 30
    //timer to update snake position ever 0.1 seconds
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            //background color
            Color.blue.opacity(0.2)

            VStack {
                Text("simple snake")
                    .font(.title)
                    .padding(.top, 30)
                Text("score: \(score)")
                    .padding(.top, 5)
                Spacer()

            }
            
            //snake body, display through the snake position array
            ZStack {
                ForEach(0..<pos_array.count, id: \.self) {
                    index in
                    Circle()
                        .fill(Color.white)
                        .frame(width: self.snake_size, height: self.snake_size)
                        .position(self.pos_array[index])
                    
                }
                //food display
                Circle()
                    .fill(Color.black)
                    .frame(width: snake_size, height: snake_size)
                    .position(food_pos)
                
            }
            //if the is_over is true (the game is over) display text
            if self.is_over {
                ZStack {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Game over :(")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Text("Score: \(self.score)")
                            .padding(.bottom, 10)

                        Button(action: {
                            resetGame()
                        }) {
                            Image(systemName: "repeat")
                                .font(.system(size: 30, weight: .bold))
                        }

                    }.foregroundColor(.white)
                    
                }
            }
            
            
            
        }.onAppear() {
            self.food_pos = self.changeCirclePos()
            print(self.food_pos)
            self.pos_array[0] = self.changeCirclePos()
            print(self.pos_array[0])
        }
        .gesture(DragGesture()
        .onChanged { gesture in
            if self.is_started {
                self.start_pos = gesture.location
                self.is_started.toggle()
            }
        }
        .onEnded {  gesture in
            let x_dist =  abs(gesture.location.x - self.start_pos.x)
            let y_dist =  abs(gesture.location.y - self.start_pos.y)
            if self.start_pos.y <  gesture.location.y && y_dist > x_dist {
                self.snake_dir = direction.down
            }
            else if self.start_pos.y >  gesture.location.y && y_dist > x_dist {
                self.snake_dir = direction.up
            }
            else if self.start_pos.x > gesture.location.x && y_dist < x_dist {
                self.snake_dir = direction.right
            }
            else if self.start_pos.x < gesture.location.x && y_dist < x_dist {
                self.snake_dir = direction.left
            }
            self.is_started.toggle()
            }
        )
            .onReceive(timer) { (_) in
                if !self.is_over {
                    self.changeDirection()
                    if self.pos_array[0] == self.food_pos {
                        self.pos_array.append(self.pos_array[0])
                        self.food_pos = self.changeCirclePos()
                        self.score += 1
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
        //create constants for screen border
        let min_x = UIScreen.main.bounds.minX
        let max_x = UIScreen.main.bounds.maxX
        let min_y = UIScreen.main.bounds.minY
        let max_y = UIScreen.main.bounds.maxY
        
        func changeDirection() {
            //detect whether the snake is outside of the border with if/else statements
            
            //if the snakehead is less than minX or it is greater than the maxX and the game is NOT over already, toggle the is_over
            
            //snake head while always be the first index in the array
            
            if self.pos_array[0].x < min_x || self.pos_array[0].x > max_x && !is_over {
                is_over.toggle()
            }
            else if self.pos_array[0].y < min_y || self.pos_array[0].y > max_y && !is_over {
                is_over.toggle()
            }
            
            var previous_position = pos_array[0]
            
            if snake_dir == .down {
                self.pos_array[0].y += snake_size
            } else if snake_dir == .up {
                self.pos_array[0].y -= snake_size
            } else if snake_dir == .left {
                self.pos_array[0].x += snake_size
            } else  {
                self.pos_array[0].x -= snake_size
            }
            
            //for loop to update the direction of the snake body
            for snake_body_part in 1..<pos_array.count {
                let current = pos_array[snake_body_part]
                pos_array[snake_body_part] = previous_position
                previous_position = current
            }
        }
        
        
        
        
        
        //function to determine the space of the screen and generate and random point within the border
        func changeCirclePos() -> CGPoint {
            let rows = Int(max_x / snake_size)
            let cols = Int(max_y / snake_size)
            
            let random_x = Int.random(in: 1..<rows) * Int(snake_size)
            let random_y = Int.random(in: 1..<cols) * Int(snake_size)
            
            return CGPoint(x: random_x, y: random_y)
        }
    
    func resetGame() {
        self.is_over = false
        self.restart_game = false
        self.score = 0
        self.pos_array.removeAll()
        self.food_pos = self.changeCirclePos()
        self.pos_array = [CGPoint(x: 0, y: 0)]
        self.pos_array[0] = self.changeCirclePos()
    }
}







struct GameCircle: View {
    var color: Color
    @State var position: CGPoint
    var size: CGFloat
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .position(position)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
