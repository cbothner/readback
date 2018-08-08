import { DirectUpload } from "activestorage"
// Turn off the default Trix captions
Trix.config.attachments.preview.caption = {
  name: false,
  size: false,
}
//
// function uploadAttachment (attachment) {
//   // Create our form data to submit
//   const file = attachment.file
//   let form = new FormData()
//   form.append('Content-Type', file.type)
//   form.append('photo[image]', file)
//
//   // Create our XHR request
//   let xhr = new XMLHttpRequest()
//   xhr.open('POST', '/photos.json', true)
//   xhr.setRequestHeader('X-CSRF-Token', Rails.csrfToken())
//
//   // Report file uploads back to Trix
//   xhr.upload.onprogress = function (event) {
//     let progress = (event.loaded / event.total) * 100
//     attachment.setUploadProgress(progress)
//   }
//
//   // Tell Trix what url and href to use on successful upload
//   xhr.onload = function () {
//     if (xhr.status === 201) {
//       let data = JSON.parse(xhr.responseText)
//       return attachment.setAttributes({
//         url: data.image_url,
//         href: data.url,
//       })
//     }
//   }
//
//   return xhr.send(form)
// }
//


const uploadFile = (file) => {
  // your form needs the file_field direct_upload: true, which
  //  provides data-direct-upload-url
  // const url = input.dataset.directUploadUrl
  let upload = new DirectUpload(file, '/rails/active_storage/direct_uploads')

  upload.create((error, blob) => {
    if (error) {
      // Handle the error
      console.log('Error uploading file from Trix');
    } else {
      // Add an appropriately-named hidden input to the form with a
      //  value of blob.signed_id so that the blob ids will be
      //  transmitted in the normal upload flow
      const hiddenField = document.createElement('input')
      hiddenField.setAttribute("type", "hidden");
      hiddenField.name = "dj[images][]"
      hiddenField.setAttribute("value", blob.signed_id);
      document.querySelector('form').appendChild(hiddenField)
    }
  })
}

// Listen for the Trix attachment event to trigger upload
addEventListener('trix-attachment-add', (event) => {
  const attachment = event.attachment
  if (attachment.file) {
    return uploadFile(attachment.file)
  }
})
