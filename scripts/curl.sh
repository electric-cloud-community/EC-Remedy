endpoint=$REMEDY_ENDPOINT
# Login
token=$(curl -H "Content-Type: application/x-www-form-urlencoded" -X POST "$endpoint/api/jwt/login?username=$REMEDY_USER&password=$REMEDY_PASSWORD" )
echo $token
#token=$(echo ${login##*token\":\"} | cut -d '"'-f 1)
#echo $token


# GET
# curl -H "Authorization: AR-JWT $token" -X GET "$endpoint/api/arsys/v1/entry/HPD:IncidentInterface/INC000000000014"

# POST
#curl -H "Authorization: AR-JWT $token" -H "Content-Type: application/json" -X POST "$endpoint/api/arsys/v1/entry/HPD:IncidentInterface_Create" \
#	-d '{"values" : {"First_Name" : "Allen" , "Last_Name" : "Allbrook" , "Description" : "REST API: Incident Creation" , "Impact" : "1-Extensive/Widespread" , "Urgency" : "1-Critical" , "Status" : "Assigned" ,  "Reported Source" : "Direct Input" ,  "Service_Type" : "User Service Restoration" ,  "z1D_Action" : "CREATE" }}' $@


# PUT
#curl -H "Authorization: AR-JWT $token" -H "Content-Type: application/json" -X PUT "$endpoint/api/arsys/v1/entry/HPD:IncidentInterface/INC000000000110|INC000000000110" \
#	-d '{"values" : {   "Description":"EF Test 1" } }' $@


# PUT
curl -H "Authorization: AR-JWT $token" -H "Content-Type: application/json" -X PUT "$endpoint/api/arsys/v1/entry/HPD:IncidentInterface_Create/000000000000004" \
       -d '{"values" : {   "Description":"EF Test 1", "Urgency" : "4-Low" } }' $@



#curl  -H "Authorization: AR-JWT $token"  'http://ec2-18-234-207-236.compute-1.amazonaws.com:8008/api/arsys/v1/entry/HPD:IncidentInterface_Create?fields=values(Incident%20Number)' $@
#curl -H "Authorization: AR-JWT $token" "$endpoint/api/arsys/v1/entry/HPD:IncidentInterface_Create"


echo

