# Profile  Viewer

## Problem Statement
 Implement a server where users can log in using a username and password.

After logging in, the user should be able to view his profile with following details : 
a) Name 
b) Image 
c) Job Role, 
d) Company Name(Clickable. Clicking on this should take you to the company details page)

Company Details page should have the following details : 
a) Company Name 
b) Logo 
c) Address 
d) Unique users currently viewing this company page 
e) Total views for this company page

Implement the system in such a way that it can be scaled to handle 10 Million users and 1 million companies


# Technology stack used

- Ruby on Rails (backend server)
- Redis (cache db)
- MongoDb (backend db)

## Installation

- Clone repo from 
```git clone ```
- Install dependencies
```bundel install```
- Run migrations
```rake db:migrate```
- Run rails server
```rails server```

## APIs

 ### **Create a user/SignUp**
> URL: host/users
	>Method: POST
	>Body Params: 
		 > 1.) name (string)
		> 2.) job_role (string)
		> 3.) email (string)
		4.) password (string)
		5.) company_id (Object_id/BSON)
		6.) image (file)
``` 
curl -X POST \
  http://127.0.0.1:3000/users/ \
  -d '{
	"name": "Test",
	"email": "test@123.com",
	"password": "123",
	"job_role": "admin",
	"company_id": "5cfcbe7fa4e2bd457446dd9b" 
}'
 -F image=@/home/aarush/image.jpg
 ```

>Sample response
```
{
    "_id": {
        "$oid": "5cfd2dada4e2bd46cd0438c6"
    },
    "auth_expiry_time": null,
    "auth_token": null,
    "company_id": {
        "$oid": "5cfcbe7fa4e2bd457446dd9b"
    },
    "email": "test@123.com",
    "image_content_type": jpg,
    "image_file_name": image.jpg,
    "image_file_size": 235,
    "job_role": "admin",
    "name": "Test",
    "password_digest": "$2a$12$ued.tjq/5cFu4WLrAvvP.OgrnBxWE0V6V/j074vvlGYFLR8KCAgtO"
}
```
### **Login User**
> URL: host/user/login
	Method: PUT
	Query Params:
	1.) email
	2.) password
```
curl -X PUT \
  'http://127.0.0.1:3000/user/login?email=test@123.com&password=123' \
  ```
  > Sample Response
  ```
  {
    "_id": {
        "$oid": "5cfcfa63a4e2bd161cbaff95"
    },
    "auth_expiry_time": "2019-06-09T17:08:24.212Z",
    "auth_token": "AfLMPLZrrLY=",
    "company_id": {
        "$oid": "5cfcbe7fa4e2bd457446dd9b"
    },
    "email": "test@123.com",
    "image_content_type": jpg,
    "image_file_name": image.jpg,
    "image_file_size": 235,
    "image_fingerprint": null,
    "job_role": admin,
    "name": "Test",
    "password_digest": "$2a$12$IZUtgmNBxGBgHoN7pFIEG.jfmqkoniyzv1bKzDEARwO4PnwSxiape"
}
  ```

### **View User**
```
curl -X POST \
  http://127.0.0.1:3000/user/profile \
  -H 'Authorization: lttz0JMTGHM=' \
```

> Sample Response
```
{ "_id": { "$oid": "5cfcfa63a4e2bd161cbaff95" }, "auth_expiry_time": "2019-06-09T17:08:24.212Z",
 "auth_token": "AfLMPLZrrLY=",
 "company_id": { "$oid": "5cfcbe7fa4e2bd457446dd9b" }, 
 "email": "test@123.com", 
 "image_content_type": jpg, 
 "image_file_name": image.jpg, 
 "image_file_size": 235, 
 "image_fingerprint": null, 
 "job_role": admin, 
 "name": "Test", 
 "password_digest": "$2a$12$IZUtgmNBxGBgHoN7pFIEG.jfmqkoniyzv1bKzDEARwO4PnwSxiape" }
```

### **Create  company**
> URL: host/companies
> Method: POST
> Body Params:
> 1.) name
> 2.) address
 ```
 curl -X POST \
  http://127.0.0.1:3000/companies \
  -d '{
	"name": "Test",
	"address": "Delhi"
}'
 ```
> Sample Response
 ```
 {
    "_id": {
        "$oid": "5cfd3053a4e2bd46cd0438c7"
    },
    "address": "Delhi",
    "name": "Test",
    "total_views": 0,
    "unique_views": 0
}
 ```

### **View Company**
> URL: host/user/:user_id/company/:company_id
> Method: PUT
```
curl -X PUT \
  http://127.0.0.1:3000/user/5cfcfa63a4e2bd161cbaff95/company/5cfcbe7fa4e2bd457446dd9b/ \
```
> Sample Response
```
{ "_id": { "$oid": "5cfd3053a4e2bd46cd0438c7" }, 
"address": "Delhi", 
"name": "Test", 
"total_views": 1, 
"unique_views": 1 
}
```

## Architecture for problems statements
 > Flow of the  application
 > -
 > - User can login using email id and password(Login API)
 > - Auth token will be generated for a user 
 > - Users can use this auth token to view their profile( View User API) 

> Redis
> -
> - Used in caching the request for scaling purposed. 
> User response is stored against the auth_token with the reamining time as its time to live.
> - Used in calculating unique company views.
> user_id and comoany_id is stored for checking unique views.