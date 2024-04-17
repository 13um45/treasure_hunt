# Treasure Hunt Game API

This Rails application provides a platform for a treasure hunt game where players create guesses
based on coordinates, authenticate using tokens, and track winners who have successfully located
treasures.

### Things to note:

To stay within the time allotted for this project these tradeoffs were made:
- Skipped adding a service layer to both the PlayersController and AuthenticationController. The
  GuessesController is a good example of how I would clean up logic in those controllers.
- I didn't fully setup action mailer so currently, mailings don't actually send. If you run the
  server in an extra window you can see what the mailings look like via server logs (including the
  temp token).
- I skipped adding test coverage for models without custom validations or custom methods. The
  guess model has specs to test validation I added.
- I also skipped test coverage for the service layer (interactors), usually I like to add unit
  specs for each interactor, as well as an integration spec for the organizer. In this case I
  decided to fully test the Guesses request spec to account for all of the logic in the service
  layer. So, via that spec the interactors should be tested.

**This challenge was designed to be reviewed commit by commit, with extra context in each commit 
around what is being done.** 

## Overview of Controllers

### PlayersController

- **Functionality**: Registers a new player using an email address.
- **Process**:
    - If the player does not exist, they are created and an email is sent with a temporary token.
    - This temporary token is used to generate a long-lived token necessary for playing the game.

### AuthenticationController

- **Functionality**: Manages the generation of LongLivedTokens.
- **Process**:
    - Receives a TemporaryToken and validates its authenticity and expiration.
    - If valid, a LongLivedToken is created, hashed, and stored in the database, then returned to
      the player.
    - This token is required for game participation.

### GuessesController

- **Functionality**: Handles the creation of guesses based on player-supplied coordinates.
- **Business Logic**:
    - Utilizes the `interactor` gem to encapsulate business logic.
    - **Steps**:
        1. **AuthenticatePlayer**: Validates the LongLivedToken. Returns an unauthorized error if
           invalid.
        2. **CalculateDistance**: Uses Google's API via the `geokit` gem to calculate the distance
           to the nearest treasure. Returns a not_found error if no treasures are available.
        3. **CreatePlayerGuess**: Attempts to create a guess record. If unsuccessful, returns an
           error. Sets messages indicating whether the guess was a win or loss.
        4. **EmailWinner**: If the guess is a winner, sends a confirmation email to the player.

### WinnersController

- **Functionality**: Provides a list of game winners.
- **Features**:
    - Allows sorting and pagination of the winner's list based on their distance from the treasure.

---

# Getting Started with the Treasure Hunt Game API

This guide will walk you through setting up and running the Treasure Hunt Game API on your local
development environment.

## Clone the Repository

First, clone the repository to your local machine:

```bash
git clone git@github.com:13um45/treasure_hunt.git
cd treasure_hunt
```

## Install Dependencies

```bash
bundle install
```

## Database Setup

```bash
rails db:create
rails db:migrate
```

## Add credentials

**Development Environment**: Im using the `dotenv` gem. Create a `.env` file in the root
directory and add the API key below:

```
GOOGLE_API_KEY=API_KEY_PROVIDED
```

## Start the Server

```bash
rails server
```

## Testing the Application

```bash
rspec spec
```

## Making API Requests

Once the server is running, you can make API requests to the endpoints defined in the application.
For example, to register a new player, you might use a tool like `curl`:

```bash
curl -X POST http://localhost:3000/players -H 'Content-Type: application/json' -d '{"email": "example@email.com"}'
```

This command would hit the `POST /players` endpoint, which is responsible for registering new
players.

---

# API Usage Guide

## Authentication

### Register Player

- **Endpoint**: `POST /players`
- **Payload**: `{"email": "example@email.com"}`
- **Response**: Sends back a temporary token if the player is new.

### Generate LongLivedToken

- **Endpoint**: `POST /authenticate`
- **Payload**: `{"token": "temporary_token_here"}`
- **Response**: Returns a LongLivedToken upon successful authentication.

## Game Interaction

### Make a Guess

- **Endpoint**: `POST /guesses`
- **Headers**: `Authorization: Bearer long_lived_token_here`
- **Payload**: `{"lat": 34.0522, "long": -118.2437}`
- **Response**: Returns outcome of the guess; sends a confirmation email if the guess wins.

## Winners

### List Winners

- **Endpoint**: `GET /winners`
- **Query Parameters**:
    - `page`: Page number for pagination.
    - `per_page`: Number of results per page.
    - `sort`: `asc` or `desc` based on distance from the treasure.
- **Response**: Paginated and sortable list of winners and their distances from the treasure.
