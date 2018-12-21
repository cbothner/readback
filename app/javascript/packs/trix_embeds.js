import * as Trix from 'trix'

addEventListener('trix-initialize', e => {
  if (document.querySelectorAll('.trix-button--icon-embed').length !== 0) {
    console.log('embed already on page')
    return
  }

  let toolbarEmbedBtn = document.createElement('button')
  toolbarEmbedBtn.type = 'button'
  toolbarEmbedBtn.classList =
    'trix-button trix-button--icon trix-button--icon-embed'
  toolbarEmbedBtn.title = 'Embed'
  toolbarEmbedBtn.tabIndex = -1
  toolbarEmbedBtn.setAttribute('data-trix-action', 'embed')
  toolbarEmbedBtn.setAttribute('data-trix-attribute', 'embed')

  const toolbar = document.querySelector('.trix-button-group--block-tools')
  toolbar.appendChild(toolbarEmbedBtn)

  const linkDialog = document.querySelector('.trix-dialog--link')
  let embedDialog = linkDialog.cloneNode(true)
  let embedFields = embedDialog.firstElementChild
  let embedInput = embedFields.firstElementChild

  embedInput.type = 'text'
  embedInput.disabled = false
  embedInput.placeholder = 'Paste iframe embed code here'
  embedInput.setAttribute('aria-label', 'Embed')

  let embedButtonGroup = embedInput.nextElementSibling
  let embedBtn = embedButtonGroup.firstElementChild
  embedBtn.value = 'embed'
  embedBtn.nextElementSibling.remove()

  linkDialog.insertAdjacentElement('afterend', embedDialog)

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
    const element = document.querySelector('trix-editor')
    const embedCode = embedInput.value
    const attachment = new Trix.Attachment({ content: embedCode })
    element.editor.insertAttachment(attachment)
  })
})
