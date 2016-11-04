# zombie-simulator
HP zombie simulator built in Processing for CS1 Course

Assignment description:

Create a Survivor class; a survivor will have a name, a location on the screen, an "infected" boolean, an "injured" boolean, and a number of bullets carried. Add more data if you think it is warranted.

Create an array of survivors and draw them on the screen (ellipses with names as labels are sufficient); draw them colour coded to indicate whether they are healthy, infected, or injured.

You want to know how viable your population of survivors is. Write two functions that take the array of survivors as the parameter:

one will return a percentage of survivors who are completely healthy among all the survivors
the other will return the number of bullets in the possession of healthy survivors
Write code that calls both of these functions and draws the numbers with appropriate labels.

Add movement to your simulation using a similar wandering movement used for the sheep in the simple AI demo. The infected should slowly wander toward any of the non-infected survivors. The healthy and injured should wander away from the infected, with the healthy moving more quickly than the injured. You can adjust several of the values used for the sheep to adjust the wandering behaviour.

Write a function called checkCollision that takes two survivor objects and returns a boolean. The function should return true if the two survivors are touching or overlapping, but false otherwise.

Use your function to check for collisions between survivors every frame. If an infected survivor is touching a healthy survivor, the healthy survivor should become infected 30% of the time. On the other hand, if an infected survivor touches an injured survivor, the injured survivor should become infected 60% of the time.

Use your function from above to check the percentage of healthy survivors every frame. If the percentage gets lower than 20%, reinforcements will be called in to help your shrinking group — 2 new non-infected survivors will spawn, and there will be a 25% chance they will be injured.

