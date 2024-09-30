//<script>
(function(){
  try{
    //Store dataLayer in local variable
    var dataLayer = window.dataLayer || [];
    //Fetch API
    fetch('https://yourserversideendpoint.com/test?userID=0001',{
      'method': 'GET', 
      "credentials": "include"
    })
    //Handle response from fetch promise
    .then(function(response){
      //If Firestore document doesn't exist, Firestore API return a 404 error
      if(response.status === 404){
        throw new Error('User with no transactions')
      }
      return response.json();
    })
    //Treat promise response and push to dataLayer
    .then(function(response){
      console.log(response.data);
      var object = response.data;
      object.event = 'firestore_response_ready'
      dataLayer.push(object);
    })
    //Handle error response and push empty variables to dataLayer
    .catch(function(response){
      dataLayer.push({
        purchased_items:[],
        total_purchases:0,
        total_spent:0,
        event:'firestore_response_ready'  
      })
    })
  ;
  }catch(error){}
})(); 
//</script>  