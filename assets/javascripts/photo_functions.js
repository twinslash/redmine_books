$(document).ready( function () {
    $("#book_photo")[0].onchange = function(e) {
        var photoName = randomName($("#book_photo")[0].files[0].name);

        var formData = new FormData($("form#book_form")[0]);
        var uploadTime, startUploadTime = new Date().getTime();
        var onbeforeunload = window.onbeforeunload;
        window.onbeforeunload = deletePhoto;
        $.ajax({
            url: '/books/upload_photo?photo_name=' + photoName,
            type: 'POST',
            xhr: function() {
                myXhr = $.ajaxSettings.xhr();
                if(myXhr.upload) {
                    myXhr.upload.addEventListener('progress', progressHandlingFunction, false);
                    myXhr.addEventListener('load', loadListener, false);
                }
                return myXhr;
            },
            beforeSend: beforeSendHandler,
            //success: completeHandler(),
            //error: errorHandler,
            data: formData,
            cache: false,
            contentType: false,
            processData: false
        });
        function loadListener(e) {
            uploadTime = new Date().getTime() - startUploadTime;
            $('#photo').replaceWith("<img src='/tmp/" + photoName +  "' id='photo' class='book-form-photo'/>");
            setTimeout(deletePhoto, uploadTime);
        }
        function deletePhoto() {
            $.ajax( {
                url: '/books//delete_photo?photo_name=' + photoName,
                type: 'DELETE'
            });
            window.onbeforeunload = onbeforeunload;
        }
    }
});

function randomName(name) {
    return Math.floor(Math.random()*999999999999) + name;
}

function progressHandlingFunction(e) {
    if(e.lengthComputable) {
        $('progress').attr({ value: e.loaded, max: e.total});
    }
}

function beforeSendHandler() {
    $('#photo').replaceWith("<div class='book-form-photo book-form-fake-photo' id='photo'><progress style='position:relative;left:35%;top:50%'></progress></div>");
}

