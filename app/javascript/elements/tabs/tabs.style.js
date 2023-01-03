export default `
::slotted(.tab-content) {
    display: none
}

::slotted(.tab-content.active) {
    display: block
}

ul.tab {
  list-style: none;
  margin: 20px 0;
  padding: 0px 1.5rem;
}

ul.tab li{
  display: inline-block;
  margin-right: 15px;
}

ul.tab li:last-child {
  margin-right: 0px;
}

ul.tab li a {
  text-decoration: none;
  color: #c4c4c4;
}

ul.tab li a.active {
  text-decoration: underline;
  color: black;
}
`
