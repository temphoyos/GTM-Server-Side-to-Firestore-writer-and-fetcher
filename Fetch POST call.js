//<script>
(function(){
  try{
    //Fetch API
    fetch('/test?userID=0001',{
    'method': 'POST',
    'credentials': 'include',
    //Populate variables to be included in body of POST with value returned by CJS variables
    'body':JSON.stringify({
        purchased_items:[],/*Example value, dynamically populate this array*/
        total_purchases:1,/*Example value, dynamically populate this key*/
        total_spent:23/*Example value, dynamically populate this key*/
    })
  })
  //Handle response from fetch promise
  .then(function(response){
    return response.text()
  }); 
 }
 catch(error){}
})();  
//</script> 