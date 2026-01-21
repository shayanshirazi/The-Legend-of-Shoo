'''
String Manipulation

slicing and indexing... 

strings work just like python lists... I can access specific characters in a string using the 

index of the character

'''

mystring = "hello Class!"

print(mystring[0])  # h
print(mystring[1])  # e

# Slicing 

# Slicing is when you take a subset of a string or list
# it is done in the following format mystring[start:stop:step]

# start = the begginning index of the slice
# stop = the ending index of the slice (not inclusive)
# step = the increment of the slice

print(mystring[0:5])  # hello

print(mystring[0:5:2])  # hlo

print(mystring[0:5:3])  # hl

# WHEN Slicing, if you privide only a start value then the slice will begin from that value then go to the end

print(mystring[6:])  # Class!

# when slicing if you provide only a stop value, then we will start at 0 and go to the stop 

print(mystring[:5])  # hello


# when slicing if you provide only a step value, then we will start at 0 and go to the end with the step value

print(mystring[::2])  # hloCl!


# quick command to reverse a string or list  = 

print(mystring[::-1])  # !ssalC olleh


# all of this applies for also lists.. where instead of character indexes we have item indexes
#---------------------------------------------------------------------------------------------------------------------------


# An object is an instance of a class

# a class is a blueprint for an object


class Student:

    def __init__(self,name,age,grade):
        self.name = name     #student1.name = "Tim"
                             #student1.age = 19
                             #student1.grade = 90
        self.age = age
        self.grade = grade
    
    def get_grade(self):
        print(self.age)
        return self.grade
    
    def set_grade(self,newval):
        self.grade = newval


student1 = Student("Tim",19,90)


# Inheritance is when a class inherits attributes and methods from another class

# a good example of this is if you have an animal class, 
# 
# but you want to create a dog class

# to save time, the dog class will inherit from animal class

class Animal:
    def __init__(self,name,species,movement_speed):
        self.name = name
        self.species = species
        self.movement_speed = movement_speed

    def move(self):
        print(f"{self.name} moves at {self.movement_speed} mph")



class Dog(Animal):
    def __init__(self,name,breed,movement_speed,color):

        super().__init__(name,"Dog",movement_speed)
        self.breed = breed
        self.color = color
    def move(self):

        print("Rex is a good dog")
    



mydog = Dog("Rex","German Shepard",10,"Brown")
        

mydog.move()  # Rex moves at 10 mph


#------------------------------------------------------------------------------------
    
import requests

# api stands for application programming interface

# an api is a set of rules and protocols that allows one software application 
# 
# to communicate with another

# simply put api's are how we communicate on the internet


# making a get request to a website:

# a get request is when you request data from an api

response = requests.get("https://jsonplaceholder.typicode.com/comments")


#print(response.content)
print(response.status_code) # 200 means the request was successful


# a post request is when you send data to an api

response = requests.post("https://jsonplaceholder.typicode.com/comments",data = {"name":"Tim"})




# 1. Create a string variable with the value "Python Programming" and perform the following:
#    a. Print the first and last character of the string.
#    b. Print a substring from index 0 to 6.
#    c. Print the string in reverse order.
#    d. Replace all occurrences of 'o' with '0' and print the result.
#    e. Check if the string contains the word "Programming" and print the result.




# 2. Create a class called `Car` with the following attributes and methods:
#    a. Attributes: make, model, year, speed.
#    b. Methods: accelerate (increases speed by 5), brake (decreases speed by 5), and display_speed (prints the current speed).
#    c. Add a method `honk` that prints "Beep beep!".



# 3. Create a subclass of `Car` called `ElectricCar` with the following:
#    a. Additional attribute `battery_capacity`.
#    b. Method `charge` that prints "Charging...".
#    c. Override the `accelerate` method to increase speed by 10 instead of 5.
#    d. Add a method `display_battery` that prints the current battery capacity.



# 4. Make a GET request to "https://jsonplaceholder.typicode.com/posts" and perform the following:
#    a. Print the response content and status code.
#    b. Parse the JSON response and print the title of the first post.
#    c. Count and print the number of posts made by userId 1.



# 5. Make a POST request to "https://jsonplaceholder.typicode.com/posts" with the data {"title": "foo", "body": "bar", "userId": 1} and perform the following:
#    a. Print the response content and status code.
#    b. Parse the JSON response and print the id of the created post.
#    c. Verify that the title in the response matches the title sent in the request.





mystring = "hey i am,having a great day"


list_of_words = mystring.split(",")

print(list_of_words)


'''



Linked Lists - useful for when you need to insert or delete items in the middle of a list often

# A linked list is a data structure that consists of a sequence of elements where each element points to the next element in the sequence.

# linked lists often come up in interviews


'''

# Step 1 : Create a Node class

class Node:
    def __init__(self,data,next = None):
        self.data = data
        self.next = next



# Step 2 : Creat a linked list class, this is were we store all append/delete/insert

class linkedlist:
    def __init__(self,head):
        self.head = head

    def traverse(self):
        curr = self.head
        while(curr != None): # keep going until you go to none
            print(curr.data)
            curr = curr.next

    def append(self,newnode):
        curr = self.head
        while(curr.next != None):  # keep going until you reach the end
            curr = curr.next
        curr.next = newnode  # once at the end, set the last node's next to the new node
        return self.head
    
    def insert(self,position,newnode):
        curr = self.head
        counter = 1
        while(curr != None):
            if counter == position:
                newnode.next = curr.next
                curr.next = newnode
                return self.head
            curr = curr.next
            counter += 1
    def delete(self,position):
        curr = self.head
        counter = 1
        while(curr != None):
            if counter == position:
                curr.next = curr.next.next
                return self.head
            curr = curr.next
            counter += 1



'''

 Trees 

 Binary search Trees are Special binary trees that are used to store data in a 
 sorted manner, any child with a value less than parent will go to left
 any child with a value greater than parent will go to right


 nodes can only have 2 branches max
 
 

'''

# step1 : create a node class

class TreeNode:
    def __init__(self,data,left = None,right = None):
        self.data = data
        self.left = left
        self.right = right


#step 2: create tree class :


class BST:
    def __init__(self,root):
        self.root = root

    def inorder(self,curr,searchval):
        if curr != None:
            if curr.data == searchval:
                return True
            self.inorder(curr.left)
            print(curr.data)
            self.inorder(curr.right)

    def preorder(self,curr):
        if curr != None:
            print(curr.data)
            self.preorder(curr.left)
            self.preorder(curr.right)

    def postorder(self,curr):
        if curr != None:
            self.postorder(curr.left)
            self.postorder(curr.right)
            print(curr.data)

    def breadth_first_search(self):
        queue = []
        queue.append(self.root)
        while(len(queue) != 0):
            curr = queue.pop(0)
            print(curr.data)
            if curr.left != None:
                queue.append(curr.left)
            if curr.right != None:
                queue.append(curr.right)

# write a function that returns true if a specific val is in the tree


# Practice Questions:

# 1. String Manipulation:
#    a. Create a string variable with the value "Data Structures" and perform the following:
#       i. Print the second and second last character of the string.
#       ii. Print a substring from index 5 to 10.
#       iii. Print the string in reverse order.
#       iv. Replace all occurrences of 'a' with '@' and print the result.
#       v. Check if the string contains the word "Structures" and print the result.

# 2. Classes and Objects:
#    a. Create a class called `Book` with the following attributes and methods:
#       i. Attributes: title, author, pages.
#       ii. Methods: read (prints "Reading <title> by <author>"), bookmark (prints "Bookmarking page <page>").
#    b. Create an instance of the `Book` class and call its methods.

# 3. Inheritance:
#    a. Create a subclass of `Book` called `EBook` with the following:
#       i. Additional attribute `file_size`.
#       ii. Method `download` that prints "Downloading <title>...".
#       iii. Override the `read` method to print "Reading <title> on your device".
#    b. Create an instance of the `EBook` class and call its methods.

# 4. API Requests:
#    a. Make a GET request to "https://jsonplaceholder.typicode.com/users" and perform the following:
#       i. Print the response content and status code.
#       ii. Parse the JSON response and print the name of the first user.
#       iii. Count and print the number of users with the username "Bret".

# 5. Linked Lists:
#    a. Create a linked list with the elements 1, 2, 3, 4, 5.
#    b. Write a method to find the length of the linked list.
#    c. Write a method to find the middle element of the linked list.

# 6. Binary Search Trees:
#    a. Create a binary search tree with the elements 10, 5, 15, 3, 7, 12, 18.
#    b. Write a method to find the minimum value in the tree.
#    c. Write a method to find the maximum value in the tree.
#    d. Write a method to check if the tree is a valid binary search tree.