#!/bin/bash
rm -rf c4_deployment-5
source test/bin/activate
git clone https://https://github.com/belindadunu/Deployment_5.git
cd Deployment_5
pip install -r requirements.txt
pip install gunicorn
python database.py
sleep 1
python load_data.py
sleep 1 
python -m gunicorn app:app -b 0.0.0.0 -D && echo "Done"