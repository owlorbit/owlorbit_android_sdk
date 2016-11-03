<form role="form" id="login-account">
    <fieldset>
        <div class="form-group">
            <label>Email</label>
            <input class="form-control" placeholder="E-mail" id="email" name="email" type="email" autofocus>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input class="form-control" placeholder="Password" id="password" name="password" type="password" value="">
        </div>

        <button class="btn btn-lg btn-success btn-block ladda-button" data-style="zoom-in" id="login">
            <span class="ladda-label">Go</span>
            <span class="ladda-spinner"></span>
            <div class="ladda-progress" style="width: 0px;"></div>
        </button>

        <div class="form-group">
            <div id="errorMsg">
            </div>
        </div>
        
        <br/>
        <a href="/forgot">Reset Password</a><br/>
        Don't have an account?  <a href='/create'>Register for Free!</a>
    </fieldset>
</form>