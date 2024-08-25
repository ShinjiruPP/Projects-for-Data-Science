import os
import csv
import sys

NAME_SALES_REGISTRY = "Registro vendite.csv"
NAME_PRODUCT_REGISTRY = "Registro prodotti.csv"


def initialize_sales_archive():
    """
    Function used for initialize the .csv file where will be saved all sales data.
    Try to read it, if it already exists return the list of sales, otherwise returns an error and do nothing
    :return: past_sales_list (list of sales)
    """
    try:
        current_path = os.getcwd()
        file_path = os.path.join(current_path, NAME_SALES_REGISTRY)
        past_sales_list = []

        with open(file_path, "r") as csv_file:
            csv_reader = csv.reader(csv_file)

            for i, row in enumerate(csv_reader):
                if not i == 0:
                    past_sales_list.append(row)
        return past_sales_list
    except FileNotFoundError:
        pass


def initialize_product_archive():
    """
    Function used for initialize the .csv file where will be saved all store data.
    Create the .csv if it does not exists, write the first line (headers) if does not exists
    :return: csv_reader (iterable used to read all .csv lines)
    """
    try:
        current_path = os.getcwd()
        file_path = os.path.join(current_path, NAME_PRODUCT_REGISTRY)
        past_product_list = []

        if os.path.exists(file_path):
            with open(file_path) as csv_file:
                csv_reader = csv.reader(csv_file)
                for i, row in enumerate(csv_reader):
                    if not i == 0:
                        past_product_list.append([row[0], row[1], row[2], row[3]])
        else:
            with open(file_path, "a+", newline="") as csv_file:
                csv_writer = csv.writer(csv_file)
                csv_writer.writerow(["Nome prodotto", "Quantità", "Prezzo di vendita", "Prezzo d'acquisto"])

        return past_product_list
    except FileNotFoundError as file_error:
        print(f"Si è riscontrato un errore poiché non è stato possibile trovare il file .csv: {file_error}")
    except csv.Error as csv_error:
        print(f"Si è riscontrato un errore la lettura/scrittura del file .csv: {csv_error}")


def convert_string_to_float(string):
    """
    Function used for check if a string can be converted into float number.
    Return True if it is possible otherwise returns false
    :param string: input string that need to be converted
    :return: True (if it is possible)/False (if it is not possible)
    """
    try:
        float(string)
        return True
    except ValueError:
        return False


class Store:
    """
    This class represents the store.
    Contains all the methods useful to do logics on it.
    """

    def __init__(self):
        """
        Construct for initializing the dictionary that contains all products, the list of current sales
        and the list of past sales.
        """
        try:
            self.product_dictionary = {}
            self.currently_sales_list = []
            self.past_sales_list = []

            past_product_list = initialize_product_archive()
            past_sales_list = initialize_sales_archive()

            if past_product_list is not None:
                for row in past_product_list:
                    self.product_dictionary[row[0]] = [row[1], row[2], row[3]]

            if past_sales_list is not None:
                for row in past_sales_list:
                    self.past_sales_list.append([row[0], row[1], row[2]])
        except Exception as e:
            print(f"Si è riscontrato un errore durante l'inizializzazione del magazzino: {e}")


    def add_new_product(self):
        """
        Method for adding a new product to the store.
        """
        try:
            product_name = input("Inserisci il nome del prodotto: ")
            if not product_name.isalpha():
                raise ValueError("Il nome del prodotto non è valido")

            quantity = input("Inserisci la quantità del prodotto da aggiungere: ")
            if not quantity.isdigit():
                raise ValueError("La quantità inserita non è valida")

            quantity = int(quantity)
            if quantity <= 0:
                raise ValueError("La quantità deve essere maggiore di zero")

            if product_name in self.product_dictionary.keys():
                print("Il prodotto e' gia' presente in magazzino. Le nuove quantità sono state registrate")
                self.product_dictionary[product_name][0] = int(self.product_dictionary[product_name][0]) + int(quantity)
            else:
                selling_price = input("Inserisci il prezzo di vendita: ")
                assert (convert_string_to_float(selling_price)), "Il prezzo di vendita non è valido"

                purchase_price = input("Inserisci il prezzo di acquisto: ")
                assert (convert_string_to_float(purchase_price)), "Il prezzo di acquisto non è valido"

                self.product_dictionary[product_name] = [quantity, selling_price, purchase_price]

        except Exception as e:
            print(f"Si è riscontrato un problema durante l'aggiunta di un prodotto. \n{e}")


    def show_all_current_product(self):
        """
        Method used to shown all the current products contained into store.
        """
        try:
            if not len(self.product_dictionary.items()) == 0:
                for key, value in self.product_dictionary.items():
                    print(f"Nome prodotto: {key}" +
                          f"\nQuantità: {value[0]}" +
                          f"\nPrezzo di vendita: {value[1]}€" +
                          f"\nPrezzo di acquisto: {value[2]}€")
            else:
                print("Non ci sono prodotti nel magazzino. Aggiungine!")
        except Exception as e:
            print(f"Si è riscontrato un problema durante l'elenco dei prodotti in magazzino: {e}")


    def record_a_sale(self):
        """
        Method used to record the sales
        """
        product_name = None
        add_new_product = True
        total = 0
        while add_new_product:
            try:
                print(f"I prodotti attualmente disponibili sono: ")
                for key in self.product_dictionary:
                    print(f"- {key}")

                product_name = input("Inserisci il nome del prodotto venduto: ")
                if not product_name.isalpha():
                    raise ValueError("Il nome del prodotto non è valido")

                if product_name not in self.product_dictionary:
                    raise KeyError("Il prodotto non è presente in magazzino")

                quantity = input("Inserisci la quantità del prodotto venduto: ")
                if not quantity.isdigit():
                    raise ValueError("La quantità inserita non è valida")

                quantity = int(quantity)
                if quantity <= 0:
                    raise ValueError("La quantità deve essere maggiore di zero")

                if quantity > int(self.product_dictionary[product_name][0]):
                    print("La quantità inserita è maggiore di quella disponibile in magazzino. Riprova!")
                    continue

                self.product_dictionary[product_name][0] = int(self.product_dictionary[product_name][0]) - int(quantity)

                add_new_product = input("Aggiungere un altro prodotto venduto? (si/no): ")
                if add_new_product.lower() not in ["si", "no"]:
                    raise ValueError("La risposta non è valida. Inserire 'si' o 'no'")
                add_new_product = add_new_product.lower() == "si"

                self.currently_sales_list.append([product_name, quantity, quantity * float(self.product_dictionary[product_name][1])])
                self.past_sales_list.append([product_name, quantity, quantity * float(self.product_dictionary[product_name][1])])

            except ValueError as e:
                print(f"Si è riscontrato un problema durante l'aggiunta di un prodotto alla vendita: {e}")

        print("La vendita dei prodotti è stata registrata correttamente:")
        for sale in self.currently_sales_list:
            print(f"- {sale[1]}x {sale[0]}: {self.product_dictionary[sale[0]][1]}€")
            total = total + float(sale[2])
        print(f"Il totale della vendita e': {total}€")

        if self.product_dictionary[product_name][0] == 0:
            del self.product_dictionary[product_name]


    def save_all_product(self):
        """
        Method used to save all product into .csv file before closing the program
        """
        try:
            global NAME_PRODUCT_REGISTRY

            with open(os.path.join(os.getcwd(), NAME_PRODUCT_REGISTRY), "r") as csv_file:
                header = next(csv_file)

            with open(os.path.join(os.getcwd(), NAME_PRODUCT_REGISTRY), "w", newline="") as csv_file:
                csv_writer = csv.writer(csv_file)
                csv_file.write(header)
                list_of_keys = self.product_dictionary.keys()
                for key in list_of_keys:
                    csv_writer.writerow([key, self.product_dictionary[key][0], self.product_dictionary[key][1],
                                         self.product_dictionary[key][2]])
        except FileNotFoundError as file_error:
            print(f"Si è riscontrato un errore poiché non è stato possibile trovare il file .csv: {file_error}")
        except csv.Error as csv_error:
            print(f"Si è riscontrato un errore la lettura/scrittura del file .csv: {csv_error}")


    def save_all_sales(self):
        """
        Method used for save all product sales into .csv file before closing the program
        """
        try:
            file_exists = os.path.exists(os.path.join(os.getcwd(), NAME_SALES_REGISTRY))
            with open(os.path.join(os.getcwd(), NAME_SALES_REGISTRY), "a+", newline="") as csv_file:
                csv_writer = csv.writer(csv_file)
                if not file_exists:
                    csv_writer.writerow(["Nome prodotto", "Quantità", "Prezzo di vendita totale"])
                for row in self.currently_sales_list:
                    csv_writer.writerow([row[0], row[1], row[2]])

        except FileNotFoundError as file_error:
            print(f"Si è riscontrato un errore poiché non è stato possibile trovare il file .csv: {file_error}")
        except csv.Error as csv_error:
            print(f"Si è riscontrato un errore la lettura/scrittura del file .csv: {csv_error}")


    def calculate_profits(self):
        """
        Method used for calculates the profits
        """
        try:
            gross_profit = 0.0
            net_profit = 0.0
            for sale in self.past_sales_list:
                gross_profit += float(sale[2])
                net_profit += float(sale[2]) - int(sale[1]) * float(self.product_dictionary[sale[0]][2])

            print(f"Il profitto lordo delle vendite e': {gross_profit}€" +
                  f"\nIl profitto netto delle vendite e': {net_profit}€")

        except IndexError as e:
            print(f"Si è riscontrato un errore durante il calcolo dei profitti: {e}")
        except KeyError as e:
            print(f"Si è riscontrato un errore durante il calcolo dei profitti: {e}")


store = Store()

cmd = None

while cmd != "chiudi":

    cmd = input("Inserisci un comando: ")

    if cmd == "aggiungi":

        store.add_new_product()

    elif cmd == "elenca":

        store.show_all_current_product()

    elif cmd == "vendita":

        store.record_a_sale()

    elif cmd == "profitti":

        store.calculate_profits()

    elif cmd == "aiuto":

        print("Inserisci il comando 'aggiungi' per aggiungere un prodotto al magazzino" +
              "\nInserisci il comando 'elenca' per elencare i prodotti attualmente in magazzino" +
              "\nInserisci il comando 'vendita' per registrare una vendita effettuata" +
              "\nInserisci il comando 'profitti' per visualizzare i profitti totali" +
              "\nInserisci il comando 'aiuto' per mostrare i possibili comandi" +
              "\nInserisci il comando 'chiudi' per chiudere il programma")

    elif cmd == "chiudi":

        print("Il programma è terminato! Arrivederci!")
        store.save_all_product()
        store.save_all_sales()
        sys.exit()

    else:
        print("Il comando inserito non è disponibile. Prova ad inserire 'aiuto' per visualizzare quelli disponibili!")
