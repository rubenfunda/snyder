```node.js
const express = require("express")
  // , mongo = require('mongodb')
  // , mongoose = require('mongoose')
  , bodyParser = require('body-parser')
  , fs = require('fs')
  , path = require('path')
  , session = require('express-session')
  // , passport = require('passport')
  , config = require('./config/database')
  , cookieParser = require('cookie-parser')
  , helmet = require('helmet');

var PORT = process.env.PORT;

const app = express();
const http = require('http').createServer(app);
const io = require('socket.io')(http);

// mongoose.connect(config.database, {useNewUrlParser:true, useUnifiedTopology: true}, (err) =>{
//   if (err) console.log(err);
// });
// let db = mongoose.connection;
//
// mongoose.set('useNewUrlParser', true);
// mongoose.set('useFindAndModify', false);
// mongoose.set('useCreateIndex', true);
// // Check connection
// db.once('open', () => {
//   console.log('connected to mongoDB and mongoose');
// });
//
// // Check for DB errors
// db.on('error', (error) => console.log(error));

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }))

app.use(express.static(__dirname));
app.use(bodyParser.urlencoded({ extended: true}));
app.use(bodyParser.json());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public'), {
  // maxAge:2592000000
}));

app.use(helmet()); // Security
app.disable('x-powered-by'); // Security
app.set('trust proxy', 1); // Other
app.use(session({ // Session
  secret: 'keyboard cat',
  resave: true,
  saveUninitialized: true,
  cookie: { maxAge: 180 * 60 * 1000 }
}));

app.get('/', (req, res) => {
  res.render('home')
});


io.on('connection', (socket) => {
  console.log('a user connected');
  socket.on('disconnect', () => {
    console.log('user disconnected');
  });
});

http.listen(3000, () => {
  console.log('listening on *:3000');
});
```
