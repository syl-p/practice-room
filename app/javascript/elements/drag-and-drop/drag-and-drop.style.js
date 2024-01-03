export default `
  .drag-and-drop_container {
    border: 1px dashed;
    margin-bottom: 1rem;
    padding: 3rem;
    position: relative;
  }

  .drag-and-drop_container-drop.is-over {
    border: 1px solid;
  }

  .drag-and-drop ::slotted(input) {
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    opacity: 0;
  }
`
