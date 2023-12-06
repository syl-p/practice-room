export default `
::slotted(.tab-content) {
    display: none
}

::slotted(.tab-content.active) {
    display: block
}

ul.tab {
  padding: 0px;
  list-style: none;
  display: flex;
  gap: 10px;
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
