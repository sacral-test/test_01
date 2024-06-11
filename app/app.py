Here is an example of Python Flask API code that implements the given user story:

```python
from flask import Flask, request, jsonify

app = Flask(__name__)

# Sample data for events
events = [
    {
        'name': 'Music Concert',
        'date': '2022-10-15',
        'time': '19:00',
        'location': 'City Hall',
        'category': 'music',
        'interests': ['rock', 'pop']
    },
    {
        'name': 'Sports Tournament',
        'date': '2022-11-05',
        'time': '14:00',
        'location': 'Sports Complex',
        'category': 'sports',
        'interests': ['football', 'basketball']
    },
    {
        'name': 'Art Exhibition',
        'date': '2022-12-01',
        'time': '10:00',
        'location': 'Art Gallery',
        'category': 'arts',
        'interests': ['painting', 'sculpture']
    }
]

@app.route('/events', methods=['GET'])
def get_events():
    # Get query parameters for filters
    category = request.args.get('category')
    date = request.args.get('date')
    interests = request.args.getlist('interests')

    filtered_events = []

    # Apply filters to events
    for event in events:
        if category and event['category'] != category:
            continue
        if date and event['date'] != date:
            continue
        if interests and not set(interests).intersection(event['interests']):
            continue
        filtered_events.append(event)

    return jsonify(filtered_events)

if __name__ == '__main__':
    app.run(debug=True)
```

In this code, we define a Flask API with a single endpoint `/events` that accepts GET requests. The endpoint retrieves the query parameters for filters (category, date, and interests) from the request. It then applies these filters to the `events` data and returns the filtered events as a JSON response.

To test the API, you can run the code and make GET requests to `http://localhost:5000/events` with the desired filters as query parameters. For example, to filter events by category 'music' and interests 'rock' and 'pop', you can make a request to `http://localhost:5000/events?category=music&interests=rock&interests=pop`.

Note that this is a simplified example and does not include features like pagination, detailed event pages, or user profiles. You can extend the code to include these features based on your specific requirements.