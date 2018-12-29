import * as Trix from 'trix'

const createToolbarEmbedBtn = () => {
  let btn = document.createElement('button')
  btn.classList = 'trix-button trix-button--icon trix-button--icon-embed'
  btn.setAttribute('type', 'button')
  btn.setAttribute('title', 'Embed')
  btn.setAttribute('tabIndex', -1)
  btn.setAttribute('data-trix-action', 'embed')
  btn.setAttribute('data-trix-attribute', 'embed')
  return btn
}

const createEmbedDialog = toolbar => {
  const linkDialog = toolbar.querySelector('.trix-dialog--link')
  const embedDialog = linkDialog.cloneNode(true)
  delete embedDialog.dataset.trixDialogAttribute
  linkDialog.insertAdjacentElement('afterend', embedDialog)
  return embedDialog
}

const setEmbedInput = elem => {
  elem.disabled = false
  elem.setAttribute('type', 'text')
  elem.setAttribute('placeholder', 'Paste iframe embed code here')
  elem.setAttribute('aria-label', 'Embed')
}

const setEmbedBtn = elem => {
  elem.setAttribute('value', 'embed')
  elem.nextElementSibling.remove()
}

addEventListener('trix-initialize', event => {
  if (event.target.dataset.trixPreventEmbeds) {
    return
  }

  const toolbar = event.target.toolbarElement
  let blockTools = toolbar.querySelector('.trix-button-group--block-tools')

  let toolbarEmbedBtn = createToolbarEmbedBtn()
  blockTools.appendChild(toolbarEmbedBtn)

  let embedDialog = createEmbedDialog(toolbar)

  let embedInput = embedDialog.firstElementChild.firstElementChild
  setEmbedInput(embedInput)

  let embedBtn = embedInput.nextElementSibling.firstElementChild
  setEmbedBtn(embedBtn)

  // event listeners //

  toolbarEmbedBtn.addEventListener('click', () => {
    if (embedDialog.dataset.trixActive === '') {
      delete embedDialog.dataset.trixActive
    } else {
      embedDialog.dataset.trixActive = ''
      embedInput.disabled = false
    }
  })

  embedBtn.addEventListener('click', () => {
    if (!embedInput.value) return
    const embedCode = embedInput.value
    const attachment = new Trix.Attachment({ content: embedCode })
    event.target.editor.insertAttachment(attachment)
  })
})
