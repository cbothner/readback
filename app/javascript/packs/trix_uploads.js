import { DirectUpload } from 'activestorage'
import * as Trix from 'trix'

Trix.config.attachments.preview.caption = {
  name: false,
  size: false,
}

const uploadAttachment = attachment => {
  const file = attachment.file
  let upload = new DirectUpload(file, '/rails/active_storage/direct_uploads')

  return new Promise((resolve, reject) => {
    upload.create((error, blob) => {
      if (error) {
        reject(new Error('Error uploading file from Trix'))
      } else {
        attachment.setAttributes({
          url:
            '/rails/active_storage/blobs/' +
            blob.signed_id +
            '/' +
            encodeURIComponent(blob.filename),
        })

        resolve(blob.signed_id)
      }
    })
  })
}

function getAssociatedInput (trixEditor) {
  return document.getElementById(trixEditor.getAttribute('input'))
}

function getHiddenInputName (associatedInput) {
  const [model] = associatedInput.getAttribute('name').split('[')
  return `${model}[images][]`
}

function addHiddenInput (trixEditor, blobId) {
  const associatedInput = getAssociatedInput(trixEditor)

  const hiddenField = document.createElement('input')
  hiddenField.setAttribute('type', 'hidden')
  hiddenField.name = getHiddenInputName(associatedInput)
  hiddenField.setAttribute('value', blobId)

  associatedInput.insertAdjacentElement('afterend', hiddenField)
}

// Listen for the Trix attachment event to trigger upload
// If Trix editor has prevent-uploads data attribute, disallow upload
addEventListener('trix-attachment-add', event => {
  const trixEditor = event.target

  if (trixEditor.dataset.trixPreventUploads) {
    return event.preventDefault()
  }
  const attachment = event.attachment
  if (attachment.file) {
    return uploadAttachment(attachment).then(blobId => {
      addHiddenInput(trixEditor, blobId)
    })
  }
})
