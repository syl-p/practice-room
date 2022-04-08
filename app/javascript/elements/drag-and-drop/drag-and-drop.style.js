export default `
  .drag-and-drop {
    border: 1px dashed;
    margin-bottom: 1rem;
    padding: 3rem;
    position: relative;
  }

  .drag-and-drop.is-over {
    border: 1px solid;
  }

  .drag-and-drop.has-file {
    border:  3px solid blue;
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
