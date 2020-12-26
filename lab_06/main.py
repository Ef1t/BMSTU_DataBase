import database

def menu():
    print("Choose options:")
    print("1 - Scalar query")
    print("2 - Query with JOIN")
    print("3 - ")
    print("4 - Query on metadata")
    print("5 - Scalar function")
    print("6 - ")
    print("7 - Procedure")
    print("8 - System procedure or function")
    print("9 - Create new table")
    print("10 - Insert new data")
    print("11 - Delete new table")

    print("\n0 - Exit \n")

if __name__ == "__main__":

    cybersportsmenDB = database.DataBase()

    run = True
    while (run == True):
        menu()

        choice = int(input("Please, input your choice\n"))

        if choice == 1:
            print(cybersportsmenDB.get_player_with_max_rating())
        elif choice == 2:
            print(cybersportsmenDB.select_more_inf()) 
        elif choice == 3:
            print(cybersportsmenDB.select_cte_window())
        elif choice == 4:
            print(cybersportsmenDB.select_metadata())
        elif choice == 5:
            print(cybersportsmenDB.scalar_func('NAVI'))
        elif choice == 6:
            print(cybersportsmenDB.multi_table_func())
        elif choice == 7:
            cybersportsmenDB.team_between_id(1, 6, 'Super Team')
        elif choice == 8:
            print(cybersportsmenDB.get_version())
        elif choice == 9:
            cybersportsmenDB.create_table('cs_role')
        elif choice == 10:
            cybersportsmenDB.insert_data('cs_role', 'lurker', 400)
        elif choice == 0:
            run = False
