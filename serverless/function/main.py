import requests
import pickle
from google.cloud import storage

def classifier(request):

    if request.method == 'GET':
        return 'Welcome to the ML Deployment Basics API! Please send a POST request with your data to get predictions.'
    
    pred_class = ''
    if request.method == 'POST':
        data = request.get_json()
        if not data or 'model' not in data or 'x' not in data:
            return {'error': "Request must include 'model' and 'x' fields"}, 400

        storage_client = storage.Client()
        bucket = storage_client.bucket('lamphan-classifier-models')

        if data['model'] == 'DecisionClassifier':
            blob = bucket.blob('decision_tree_clf/model.pkl')

        elif data['model'] == 'LinearSVC':
            blob = bucket.blob('linear_svc_clf/model.pkl')

        else:
            blob = bucket.blob('logistic_regression_clf/model.pkl')

        blob.download_to_filename('/tmp/model.pkl')
        model = pickle.load(open('/tmp/model.pkl', 'rb'))

        x_data = data['x']
        output = model.predict(x_data)

        pred_class = 'Text:' + str(x_data) + '\nPrediction:' + str(output)

    return pred_class