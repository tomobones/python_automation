
# ----------------------------------------------------------------------------
# calculate rent per person

from enum import Enum

class Room(Enum):
    one_west = 0
    one_guest = 1
    one_kitchen = 2
    one_east = 3
    two_west = 4
    two_guest = 5
    two_kitchen = 6
    two_east = 7
    three_west = 8
    three_north = 9
    three_east = 10
    baths = 11

# ----------------------------------------------------------------------------
# functions

def init_squares_per_room():
    global squares_per_room
    global total_squares

    squares_per_room[Room.one_west] = 18
    squares_per_room[Room.one_guest] = 10
    squares_per_room[Room.one_kitchen] = 10
    squares_per_room[Room.one_east] = 23
    squares_per_room[Room.two_west] = 18
    squares_per_room[Room.two_guest] = 10
    squares_per_room[Room.two_kitchen] = 10
    squares_per_room[Room.two_east] = 23
    squares_per_room[Room.three_west] = 18
    squares_per_room[Room.three_north] = 23
    squares_per_room[Room.three_east] = 23
    squares_per_room[Room.baths] = 10

def init_owners_per_rooms():
    global owners
    global owners_per_room

    owners_per_room[Room.one_west] = ['Kili', 'Feli']
    owners_per_room[Room.one_guest] = owners
    owners_per_room[Room.one_kitchen] = owners
    owners_per_room[Room.one_east] = ['Feli', 'Kili']
    owners_per_room[Room.two_west] = ['Mara']
    owners_per_room[Room.two_guest] = owners
    owners_per_room[Room.two_kitchen] = owners
    owners_per_room[Room.two_east] = ['Carli']
    owners_per_room[Room.three_west] = ['Resi']
    owners_per_room[Room.three_north] = ['Tomo']
    owners_per_room[Room.three_east] = ['Flo']
    owners_per_room[Room.baths] = owners

def calculate_rent_complete_per_owner():
    global owners
    global owners_per_room
    global squares_per_room
    global number_squares
    global rent_complete_per_owner
    global rent_per_square
    global extra_per_owner
    global buffer_per_owner

    for owner in owners:
        number_squares = 0
        for room in Room:
            if owner in owners_per_room[room]:
                number_squares += (squares_per_room[room] / len(owners_per_room[room]))
        rent_complete_per_owner[owner] = number_squares * rent_per_square
        rent_complete_per_owner[owner] += extra_per_owner
        rent_complete_per_owner[owner] += buffer_per_owner


def print_rent_per_owner():
    print('')
    print('---------- printing rent per owner -----------')
    print('')
    print(f'total squares:   {total_squares:#.2f} m^2')
    print(f'rent per square: {rent_per_square:#.2f} EUR')
    print('')
    for owner in owners:
        print(f'{owner}\'s complete rent:\t{rent_complete_per_owner[owner]:#.2f} EUR')
    print('')
    print('----------------------------------------------')
    print('')


def main():
    print_rent_per_owner()
    
# ----------------------------------------------------------------------------
# variables

owners = ['Tomo', 'Carli', 'Feli', 'Resi', 'Flo', 'Mara', 'Kili']

total_rent   = 2514.96
total_extras = 297.90
total_buffer = 180.00

rent_per_owner   = total_rent   / len(owners)
extra_per_owner  = total_extras / len(owners)
buffer_per_owner = total_buffer / len(owners)

squares_per_room = {}
init_squares_per_room()

total_squares = 0
for room in Room:
    total_squares += squares_per_room[room]

rent_per_square = total_rent / total_squares

owners_per_room = {}
init_owners_per_rooms()

rent_complete_per_owner = {}
calculate_rent_complete_per_owner()


# ----------------------------------------------------------------------------
# main

if __name__ == "__main__":
    main()
