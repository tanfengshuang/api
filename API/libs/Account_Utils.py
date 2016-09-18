import json
import requests
import logging

from rhsm import connection

class Account_Utils():    
    def __init__(self):
        # Candlepin Server
        self.stage_candlepin_server = "subscription.rhn.stage.redhat.com"
           
    def GET(self, url, info):
        logging.info(url)
        logging.info(info)      
        result = json.loads(requests.get(
                                         url,
                                         #headers={'content-type':'application/json'},
                                         #data=json.dumps(info)
                                         params=info
                                         ).content
                            )
        
        logging.info(result)
           
        if "data" in result.keys():
            msg = result["data"]
        else:
            msg = result["msg"]
        
        return result["status"], msg
    
    def POST(self, url, info):
        logging.info(url)
        logging.info(info) 
        result = json.loads(requests.post(
                                         url,
                                         headers={'content-type':'application/json'},
                                         data=json.dumps(info)
                                         ).content
                            )
        
        logging.info(result)
              
        if "data" in result.keys():
            msg = result["data"]
        else:
            msg = result["msg"]
        
        return result["status"], msg
    
    def verify_sku(self, sku, username, password="redhat"):
        logging.info("To verify newly added sku {0} in account {1}".format(sku, username))
        try:
            con = connection.UEPConnection(self.stage_candlepin_server, username=username, password=password)
            org_id = con.getOwnerList(con.username)[0]['key']
            logging.info(org_id)
            pool_list = con.getPoolsList(owner=org_id)
            sku_list = list(set([pool['productId'] for pool in pool_list]))
            logging.info("SKU got from test account: {0}".format(sku_list))
            logging.info("Expected SKU: {0}".format(sku))
            if sku in sku_list:
                return unicode(0)
            else: 
                return unicode(1)
        except connection.RestlibException, e:
            if "Invalid username or password" in str(e):
                logging.info("{0}:{1} - You must first accept Red Hat's Terms and conditions.".format(username, password))
            else:
                logging.error(str(e))
            return unicode(1)
    
    def verify_account_login(self, username, password="redhat"):
        logging.info("verify newly created account {0}".format(username))
        try:
            con = connection.UEPConnection(self.stage_candlepin_server, username=username, password=password)
            con.getOwnerList(con.username)
            return unicode(0)
        except connection.RestlibException, e:
            if "Invalid username or password" in str(e):
                logging.info("{0}:{1} - Invalid username or password.".format(username, password))
            else:
                logging.error(str(e))
            return unicode(1)
    
    def verify_activate(self, username, password="redhat"):
        try:
            logging.info("Trying to check terms for account {0}".format(username))
            con = connection.UEPConnection(self.stage_candlepin_server, username=username, password=password)
            con.getOwnerList(con.username)
            return unicode(0)
        except connection.RestlibException, e:
            if "You must first accept Red Hat's Terms and conditions" in str(e):
                logging.info("{0}:{1} - You must first accept Red Hat's Terms and conditions.".format(username, password))
            else:
                logging.error("shuang...........")
                logging.error(str(e))
            return unicode(1)
    
    def Verify_view_result(self, msg, username, sku_quantity_list=[]):
        # msg Structure:
        # {
        #   u'username': u'user1471166602jeqt', 
        #   u'pools': [
        #              {
        #               u'sku': u'RH0103708', 
        #               u'id': u'8a99f9895672a06f0156885d2eae3b22', 
        #               u'name': u'Red Hat Enterprise Linux Server, Premium (8 sockets) (Up to 4 guests)', 
        #               u'quantity': 100
        #               }
        #              ], 
        #   u'org_id': u'8032239'
        #  }
        logging.info(msg)
        view_username = msg['username']
        view_sku_quantity_list = msg['pools']
        logging.info("username in view result: {0}".format(view_username))
        logging.info("expected username: {0}".format(username))
        logging.info("sku and quantity in view result: {0}".format(view_sku_quantity_list))
        logging.info("expected sku and quantity: {0}".format(sku_quantity_list))
        
        if username == view_username:
            if len(view_sku_quantity_list) == len(sku_quantity_list) and len(view_sku_quantity_list) == 0:
                return unicode(0)
            for i in sku_quantity_list:
                flag = 0
                sku = i['sku']
                quantity = i['quantity']
                if quantity != "unlimited":
                    quantity = int(i['quantity'])
                for j in view_sku_quantity_list:
                    view_sku = j['sku']
                    view_quantity = j['quantity']
                    if view_sku == sku and view_quantity == quantity:
                        flag = 1
                        break
                if flag == 0:
                    return unicode(1)  
            return unicode(0)           
        else:
            return unicode(1)
        
    
    def Verify_view_result1(self, msg, username, sku="", quantity=100):
        # msg Structure:
        # {
        #   u'username': u'user1471166602jeqt', 
        #   u'pools': [
        #              {
        #               u'sku': u'RH0103708', 
        #               u'id': u'8a99f9895672a06f0156885d2eae3b22', 
        #               u'name': u'Red Hat Enterprise Linux Server, Premium (8 sockets) (Up to 4 guests)', 
        #               u'quantity': 100
        #               }
        #              ], 
        #   u'org_id': u'8032239'
        #  }

        view_username = msg['username']
        view_sku = [pool['sku'] for pool in msg['pools']]
        if str(sku) == "":
            sku = []
        else:
            sku = sku.split(',')
            #view_quantity = msg['pools'][0]['quantity']
            view_quantity_list = list(set([pool['quantity'] for pool in msg['pools']]))
            if len(view_quantity_list) == 1:
                view_quantity = view_quantity_list[0]
            else:
                logging.ERROR("Cannot test quantity correctly for this account, please make sure there is only one")
        logging.info("username in view result: {0}".format(view_username))
        logging.info("expected username: {0}".format(username))
        logging.info("sku in view result: {0}".format(view_sku))
        logging.info("expected sku: {0}".format(sku))
        logging.info("quantity in view result: {0}".format(view_quantity))
        logging.info("expected quantity: {0}".format(quantity))
        if username == view_username:
            if sku == view_sku and quantity == view_quantity:
                return unicode(0)
            else:
                return unicode(1)            
        else:
            return unicode(1)
        
        
        
"""
Return Info:
1. account/new
    PASS:
    FAIL:
2. account/attach
    PASS:
    FAIL:
3. account/get
    PASS:
        {"status": "200", "data": {"username": "aaa", "pools": [], "org_id": "982917"}}
    FAIL:
4. account/refresh
    PASS:
        {"status": "200", "msg": "Pools for 'aaa' refreshed successfully"}
    FAIL:
5. search
    PASS:
    FAIL:
"""
    