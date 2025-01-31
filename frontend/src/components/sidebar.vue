<template>
    <div class="sidebar">
      <ul>
        <li><router-link to="/dashboard">Dashboard</router-link></li>
        <li><router-link to="/users">Users</router-link></li>
        <li><router-link to="/settings">Settings</router-link></li>
      </ul>
    </div>
  </template>
  
  <script>
  export default {
    name: 'Sidebar'
  }
  </script>
  
  <style scoped>
  .sidebar {
    width: 250px;
    background-color: #2c3e50;
    color: white;
  }
  .sidebar ul {
    padding: 0;
    list-style: none;
  }
  .sidebar li {
    padding: 10px;
  }
  </style>
  